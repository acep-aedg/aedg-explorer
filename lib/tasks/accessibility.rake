require "plane_client"
require_relative "accessibility_helpers"
require "json"

namespace :accessibility do
  desc "Parse combined accessibility report JSON and create Plane work items"
  task create_work_items: :environment do
    label_id = ENV.fetch("PLANE_WORK_ITEM_LABEL_ID", nil)

    violations = AccessibilityHelpers.axe_violations
    next unless violations

    existing_titles = AccessibilityHelpers.plane_work_item_titles
    puts "Found #{existing_titles.size} existing work items in project."
    puts "Found #{violations.size} in the report."

    violations.each_with_index do |v, idx|
      title = AccessibilityHelpers.format_violation_title(v)

      if existing_titles.include?(title)
        puts "([#{idx + 1}/#{violations.size}]) Skipping duplicate: #{title}"
        next
      end

      work_item = PlaneClient.create_work_item(
        name: title,
        description_html: PlaneClient.build_work_item_description(v),
        impact: v[:impact],
        labels: [label_id].compact_blank
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
    resolved = AccessibilityHelpers.resolved_work_items
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
    stale_state_id = ENV.fetch("PLANE_STALE_STATE_ID", nil)

    if stale_state_id.blank?
      puts "Error: ENV['PLANE_STALE_STATE_ID'] not set."
      next
    end

    resolved = AccessibilityHelpers.resolved_work_items

    if resolved.empty?
      puts "No resolved work items found. Nothing to update."
      next
    end

    resolved.each do |item|
      result = PlaneClient.update_work_item(
        work_item_id: item["id"],
        payload: { state: stale_state_id }
      )
      puts result ? "Successfully marked #{item['name']} as stale." : "Failed to mark #{item['name']} as stale."
    end
  end

  desc "Identify A11y violations in the report that do not exist in Plane yet"
  task new_violations: :environment do
    violations = AccessibilityHelpers.axe_violations
    if violations.blank?
      puts "No report violations found."
      next
    end

    existing_titles = AccessibilityHelpers.plane_work_item_titles.to_set

    new_titles = violations.map { |v| AccessibilityHelpers.format_violation_title(v) }.reject { |title| existing_titles.include?(title) }

    if new_titles.blank?
      puts "No new violations found! All report violations already exist in Plane."
    else
      puts "Found #{new_titles.size} NEW violation(s) (present in report, not yet in Plane):"
      new_titles.each { |title| puts "  - #{title}" }
    end
  end

  desc "Count unique accessibility violations from the combined report"
  task violation_count: :environment do
    report = AccessibilityHelpers.load_axe_report
    next unless report

    unique_count = report.dig(:summary, :total_unique_violations)
    puts "Total Unique Violations: #{unique_count}"
  end

  desc "Get the count of existing work items in Plane"
  task existing_work_items_count: :environment do
    count = AccessibilityHelpers.plane_work_items.size
    puts "Found #{count} existing work item(s) in Plane."
  end
end
