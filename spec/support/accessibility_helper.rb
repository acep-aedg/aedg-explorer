module AccessibilityHelpers
  def expect_page_to_be_accessible(debug_versions: false)
    if debug_versions
      caps = page.driver.browser.capabilities
      puts "\n=== Test Environment Versions ==="
      puts "Capybara:   #{Capybara::VERSION}"
      puts "Selenium:   #{Selenium::WebDriver::VERSION}"
      puts "Browser:    #{caps.browser_name} #{caps.browser_version}"
      
      # Extract ChromeDriver version from the Chrome capabilities hash
      if caps["chrome"] && caps["chrome"]["chromedriverVersion"]
        puts "Driver:     ChromeDriver #{caps['chrome']['chromedriverVersion'].split(' ').first}"
      end
      puts "=================================\n"
    end
    standards = %i[wcag2a wcag2aa wcag21a wcag21aa]
    matcher = be_axe_clean.according_to(*standards)
    matcher.matches?(page)

    results = matcher.instance_variable_get(:@audit)&.results

    save_axe_report(results) if results

    expect(page).to be_axe_clean.according_to(*standards)
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
    filename = "tmp/axe-results/#{current_path.parameterize.presence || 'root'}.json"

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

  module_function

  def combine_reports(output_filename = "tmp/axe-results/combined_report.json")
    report_files = Dir.glob("tmp/axe-results/*.json") - [output_filename]
    return if report_files.empty?

    unique_violations_map = {}

    report_files.each do |file|
      data = JSON.parse(File.read(file), symbolize_names: true)

      (data[:violations] || []).each do |v|
        (v[:nodes] || []).each do |node|
          selector = node[:target]&.join(", ") || "unknown"
          fingerprint = "#{v[:id]}::#{selector}"

          unique_violations_map[fingerprint] ||= {
            rule_id: v[:id],
            impact: (node[:impact] || v[:impact]).to_s.downcase,
            description: v[:description],
            help: v[:help],
            help_url: v[:helpUrl],
            selector: selector,
            html: node[:html],
            failure_summary: node[:failureSummary],
            affected_urls: []
          }

          unique_violations_map[fingerprint][:affected_urls] |= [data[:url]]
        end
      end
    end

    unique_violations_list = unique_violations_map.values

    combined_data = {
      generated_at: Time.now.iso8601,
      summary: {
        total_pages_tested: report_files.size,
        total_unique_violations: unique_violations_list.size,
        impact_counts: calculate_impact_counts(unique_violations_list)
      },
      unique_violations: unique_violations_list
    }

    File.write(output_filename, JSON.pretty_generate(combined_data))
    puts "\n  [Axe API] Combined Accessibility Report saved to #{output_filename}"
  end

  def calculate_impact_counts(items)
    counts = { "critical" => 0, "serious" => 0, "moderate" => 0, "minor" => 0 }

    Array(items).each do |item|
      impact_level = item[:impact].to_s.downcase

      # Single reports: # of nodes, otherwise its 1 (combined report)
      increment = item.key?(:nodes) ? item[:nodes].count : 1

      if counts.key?(impact_level)
        counts[impact_level] += increment
      else
        puts "[Axe Warning] Unknown impact level found: #{impact_level}"
      end
    end

    counts
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
end
