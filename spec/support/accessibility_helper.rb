module AccessibilityHelpers
  def expect_page_to_be_accessible
    standards = %i[wcag2a wcag2aa wcag21a wcag21aa]
    matcher = be_axe_clean.according_to(*standards)
    matcher.matches?(page)

    results = matcher.instance_variable_get(:@audit)&.results

    save_axe_report(results) if results

    expect(page).to be_axe_clean.according_to(*standards)
  end

  def self.combine_reports(output_filename = "tmp/axe-results/combined_report.json")
    report_files = Dir.glob("tmp/axe-results/*.json") - [output_filename]
    return if report_files.empty?

    impact_counts = { "critical" => 0, "serious" => 0, "moderate" => 0, "minor" => 0 }

    combined_data = {
      generated_at: Time.now.iso8601,
      total_pages_tested: report_files.size,
      summary: { total_violations: 0, total_violating_nodes: 0, impact_counts: impact_counts },
      unique_violations: {}
    }

    report_files.each do |file|
      data = JSON.parse(File.read(file), symbolize_names: true)

      if (summary = data[:summary])
        combined_data[:summary][:total_violations] += summary[:violations_count].to_i
        combined_data[:summary][:total_violating_nodes] += summary[:total_violating_nodes].to_i

        (summary[:violations_impact] || {}).each do |impact, count|
          combined_data[:summary][:impact_counts][impact.to_s] += count
        end
      end

      (data[:violations] || []).each do |v|
        (v[:nodes] || []).each do |node|
          selector = node[:target]&.join(", ") || "unknown"
          fingerprint = "#{v[:id]}::#{selector}"

          combined_data[:unique_violations][fingerprint] ||= {
            rule_id: v[:id],
            impact: node[:impact] || v[:impact],
            description: v[:description],
            help: v[:help],
            help_url: v[:helpUrl],
            selector: selector,
            html: node[:html],
            failure_summary: node[:failureSummary],
            affected_urls: []
          }

          combined_data[:unique_violations][fingerprint][:affected_urls] |= [data[:url]]
        end
      end
    end

    combined_data[:unique_violations] = combined_data[:unique_violations].values

    File.write(output_filename, JSON.pretty_generate(combined_data))
    puts "\n  [Axe API] Combined Accessibility Report saved to #{output_filename}"
  end

  private

  def save_axe_report(results)
    violations = format_axe_rules(results.violations)
    incomplete = format_axe_rules(results.incomplete)

    report = {
      url: current_url,
      timestamp: Time.now.iso8601,
      summary: build_summary(violations, incomplete),
      violations: violations,
      incomplete: incomplete
    }

    FileUtils.mkdir_p("tmp/axe-results")
    filename = "tmp/axe-results/#{current_path.parameterize.presence || "root" }.json"

    File.write(filename, JSON.pretty_generate(report))
    puts "\n  [Axe API] Audit Results saved to #{filename}"
  end

  def build_summary(violations, incomplete)
    {
      violations_count: violations.count,
      total_violating_nodes: violations.sum { |v| v[:nodes].size },
      violations_impact: calculate_impact_counts(violations),
      incomplete_count: incomplete.count,
      total_nodes_to_review: incomplete.sum { |v| v[:nodes].size },
      incomplete_impact: calculate_impact_counts(incomplete)
    }
  end

  def format_axe_rules(rules)
    Array(rules).map do |rule|
      {
        id: rule.id,
        impact: rule.impact,
        description: rule.description,
        help: rule.help,
        helpUrl: rule.helpUrl,
        nodes: Array(rule.nodes).map do |node|
          {
            html: node.html,
            impact: node.impact,
            target: node.target,
            failureSummary: node.failureSummary,
            any: format_axe_checks(node.any),
            all: format_axe_checks(node.all),
            none: format_axe_checks(node.none)
          }
        end
      }
    end
  end

  def format_axe_checks(checks)
    Array(checks).map do |check|
      {
        id: check.id,
        impact: check.impact,
        message: check.message,
        data: check.data,
        relatedNodes: Array(check.relatedNodes).map do |related|
          { target: related.target, html: related.html }
        end
      }
    end
  end

  def calculate_impact_counts(rules_data)
    counts = { "critical" => 0, "serious" => 0, "moderate" => 0, "minor" => 0 }

    rules_data.each do |violation|
      impact_level = violation[:impact].to_s.downcase

      if counts.key?(impact_level)
        counts[impact_level] += violation[:nodes].count
      else
        puts "[Axe Warning] Unknown impact level found: #{impact_level}"
      end
    end

    counts
  end
end
