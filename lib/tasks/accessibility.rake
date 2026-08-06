require "plane_client"
require "json"

namespace :accessibility do
  desc "Parse combined accessibility report JSON and create Plane work items"
  task create_a11y_work_items: :environment do
    accessiblity_label_id = ENV["PLANE_ACCESSIBLITY_LABEL_ID"]
    if accessiblity_label_id.nil? || accessiblity_label_id.strip.empty?
      abort("❌ Error: Missing ENV['PLANE_ACCESSIBLITY_LABEL_ID']. Please provide your labels ID.")
    end
    
    violations = parsed_report_violations
    next unless violations

    existing_titles = current_plane_a11y_titles
    puts "ℹ️  Found #{existing_titles.size} existing [A11y] work items in project."
    puts "ℹ️  Found #{violations.size} in the report."

    violations.each_with_index do |v, idx|
      title = format_violation_title(v)

      if existing_titles.include?(title)
        puts "([#{idx + 1}/#{violations.size}]) Skipping duplicate: #{title}"
        next
      end

      work_item = PlaneClient.create_work_item(
        name: title,
        description_html: PlaneClient.build_work_item_description(v),
        impact: v[:impact],
        labels: [accessiblity_label_id]
      )

      if work_item
        puts "([#{idx + 1}/#{violations.size}]) Created: [#{work_item[:name]}](#{work_item[:url]})"
      else
        puts "Failed to create work item: #{title}"
      end
    end

    puts "Successfully synced all violations to Plane!"
  end

  desc "Identify A11y work items in Plane that no longer exist in the report"
  task resolved_work_items: :environment do
    resolved = find_resolved_work_items
    next unless resolved

    if resolved.empty?
      puts "No resolved work items found! All Plane [A11y] items are still active violations."
    else
      puts "Found #{resolved.size} RESOLVED violations(s) (resolved in code, still open in Plane):"
      resolved.each { |item| puts "  - [#{item['name']}](#{item['url']})" }
    end
  end

  desc "Update the status of resolved A11y work items to 'Stale' in Plane"
  task mark_resolved_work_items_as_stale: :environment do
    stale_state_id = ENV["PLANE_STALE_STATE_ID"]

    if stale_state_id.nil? || stale_state_id.strip.empty?
      abort("❌ Error: Missing ENV['PLANE_STALE_STATE_ID']. Please provide your Stale state ID.")
    end

    resolved = find_resolved_work_items
    next unless resolved

    if resolved.empty?
      puts "No resolved work items found. Nothing to update."
      next
    end

    resolved.each do |item|      
      success = PlaneClient.update_work_item(
        work_item_id: item["id"],
        payload: { state: stale_state_id }
      )
      puts success ? "Successfully marked #{item['name']} as stale." : "Failed to mark #{item['name']} as stale."
    end
  end

  desc "Identify A11y violations in the report that do not exist in Plane yet"
  task new_violations: :environment do
    violations = parsed_report_violations
    next unless violations

    existing_titles = current_plane_a11y_titles

    new_violations = violations.reject { |v| existing_titles.include?(format_violation_title(v)) }

    if new_violations.empty?
      puts "No new violations found! All report violations already exist in Plane."
    else
      puts "Found #{new_violations.size} NEW violation(s) (present in report, not yet in Plane):"
      new_violations.each { |v| puts "  - #{format_violation_title(v)}" }
    end
  end

  desc "Count unique accessibility violations from the combined report"
  task unique_violations_count: :environment do
    report = parse_report
    next unless report

    unique_count = report.dig(:summary, :total_unique_violations) || 0
    puts "Total Unique Violations: #{unique_count}"
  end

  desc "Get the count of existing work items in Plane"
  task existing_work_items_count: :environment do
    count = current_plane_a11y_work_items.size
    puts "Found #{count} existing [A11y] work item(s) in Plane."
  end

  desc "Get existing work items in Plane"
  task existing_work_items: :environment do
    current_plane_a11y_work_items.each do |item|
      puts "  - [#{item['name']}](#{item['url']})"
    end
  end

  def parse_report
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")
    
    unless File.exist?(report_path)
      puts "❌ Report file not found at: #{report_path}"
      return nil
    end

    JSON.parse(File.read(report_path), symbolize_names: true)
  end

  def parsed_report_violations
    report = parse_report
    report ? (report[:unique_violations] || []) : nil
  end

  def current_plane_a11y_work_items
    @current_plane_a11y_work_items ||= PlaneClient.existing_work_items.select do |item|
      item["name"].to_s.start_with?("[A11y]")
    end
  end

  def current_plane_a11y_titles
    current_plane_a11y_work_items.map { |item| item["name"].to_s }
  end

  def format_violation_title(violation)
    standardized_selector = standardize_links(violation[:selector])
    "[A11y] #{violation[:rule_id]}: #{standardized_selector}"
  end
  
  def standardize_links(selector)
    return selector unless selector.is_a?(String)

    selector
      .gsub('[rel="noopener"]', '[target="_blank"]')
      .gsub('[data-turbo-frame="_top"]', '[rel="noopener"]')
      .gsub('[target="_blank"][target="_blank"]', '[target="_blank"]')
      .gsub('[rel="noopener"][rel="noopener"]', '[rel="noopener"]')
  end

  def find_resolved_work_items
    violations = parsed_report_violations
    return nil unless violations

    report_titles = violations.map { |v| format_violation_title(v) }
    
    current_plane_a11y_work_items.reject { |item| report_titles.include?(item["name"]) }
  end
end