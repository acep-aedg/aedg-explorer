require "plane_client"

module AccessibilityHelpers
  def self.load_axe_report
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      Rails.logger.warn("AccessibilityHelpers: Report file not found at #{report_path}")
      return nil
    end

    JSON.parse(File.read(report_path), symbolize_names: true)
  rescue JSON::ParserError => e
    Rails.logger.error("AccessibilityHelpers: Failed to parse report file (invalid JSON): #{e.message}")
    nil
  end

  def self.axe_violations
    report = load_axe_report
    report ? (report[:unique_violations] || []) : nil
  end

  def self.plane_work_items
    @plane_work_items ||= PlaneClient.existing_work_items.select do |item|
      item["name"].to_s.start_with?("[A11y]")
    end
  end

  def self.plane_work_item_titles
    plane_work_items.map { |item| item["name"].to_s }
  end

  def self.format_violation_title(violation)
    standardized_selector = standardize_links(violation[:selector])
    "[A11y] #{violation[:rule_id]}: #{standardized_selector}"
  end
  
  def self.standardize_links(selector)
    return selector unless selector.is_a?(String)

    selector.gsub(/\[\s*(?:target|rel|data-turbo)[^\]]*\]/i, "")
  end

  def self.resolved_work_items
    violations = axe_violations
    return nil unless violations

    report_titles = violations.map { |v| format_violation_title(v) }

    plane_work_items.reject { |item| report_titles.include?(item["name"]) }
  end
end
