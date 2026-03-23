module AccessibilityHelpers
  def expect_page_to_be_accessible
    standards = %i[wcag2a wcag2aa wcag21a wcag21aa]
    matcher = be_axe_clean.according_to(*standards)
    matcher.matches?(page)

    results = matcher.instance_variable_get(:@audit)&.results

    save_axe_report(results) if results

    expect(page).to be_axe_clean.according_to(*standards)
  end

  private

  def save_axe_report(results)
    violations = serialize_axe_rules(results.violations)
    incomplete = serialize_axe_rules(results.incomplete)

    report = {
      url: current_url,
      timestamp: Time.now.iso8601,
      summary: build_summary(violations, incomplete),
      violations: violations,
      incomplete: incomplete
    }

    write_report_to_disk(report)
  end

  def build_summary(violations, incomplete)
    {
      violations_count: violations.count,
      total_violating_nodes: violations.sum { |v| v[:nodes].count },
      violations_impact: calculate_impact_counts(violations),
      incomplete_count: incomplete.count,
      total_nodes_to_review: incomplete.sum { |v| v[:nodes].count },
      incomplete_impact: calculate_impact_counts(incomplete)
    }
  end

  def write_report_to_disk(report)
    FileUtils.mkdir_p("tmp/axe-results")
    file_id = current_path.parameterize.presence || "root"
    filename = "tmp/axe-results/#{file_id}.json"
    File.write(filename, JSON.pretty_generate(report))
    puts "\n  [Axe API] Audit Results saved to #{filename}"
  end

  def serialize_axe_rules(rules)
    rules.map do |rule|
      {
        id: rule.id,
        impact: rule.impact,
        description: rule.description,
        help: rule.help,
        helpUrl: rule.helpUrl,
        nodes: rule.nodes.map do |node|
          {
            html: node.html,
            impact: node.impact,
            target: node.target,
            failureSummary: node.failureSummary,
            any: serialize_axe_checks(node.any),
            all: serialize_axe_checks(node.all),
            none: serialize_axe_checks(node.none)
          }
        end
      }
    end
  end

  def serialize_axe_checks(checks)
    return [] if checks.nil?

    checks.map do |check|
      {
        id: check.id,
        impact: check.impact,
        message: check.message,
        data: check.data,
        # relatedNodes is used for things like duplicate IDs or overlapping elements
        relatedNodes: (check.relatedNodes || []).map do |related|
          {
            target: related.target,
            html: related.html
          }
        end
      }
    end
  end

  def calculate_impact_counts(rules_data)
    counts = { "critical" => 0, "serious" => 0, "moderate" => 0, "minor" => 0 }

    rules_data.each do |violation|
      level = violation[:impact] || violation["impact"]
      level = level.to_s.downcase

      if counts.key?(level)
        counts[level] += violation[:nodes].count
      else
        puts "[Axe Warning] Unknown impact level found: #{level}"
      end
    end

    counts
  end
end
