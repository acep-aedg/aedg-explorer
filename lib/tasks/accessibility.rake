require "plane_client"
require "json"

namespace :accessibility do
  desc "Parse combined accessibility report JSON and create Plane tickets"
  task create_a11y_tickets: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "❌ Report file not found at: #{report_path}"
      next
    end

    report = JSON.parse(File.read(report_path), symbolize_names: true)
    violations = report[:unique_violations]

    existing_tickets = PlaneClient.existing_tickets
    existing_titles = existing_tickets.map { |ticket| ticket["name"] }
    puts "ℹ️  Found #{existing_titles.size} existing tickets in project."
    puts "ℹ️  Found #{violations.size} in the report."

    violations.each_with_index do |v, idx|
      title = "[A11y] #{v[:rule_id]}: #{v[:selector]}"

      if existing_titles.include?(title)
        puts "([#{idx + 1}/#{violations.size}]) Skipping duplicate: #{title}"
        next
      end

      description_html = PlaneClient.build_work_item_description(v)

      ticket_info = PlaneClient.create_work_item(
        name: title,
        description_html: description_html,
        impact: v[:impact],
        labels: []
      )

      if ticket_info
        puts "Created: [#{ticket_info[:name]}](#{ticket_info[:url]})"
      else
        puts "Failed to create ticket: #{title}"
      end
    end

    puts "Successfully synced all violations to Plane!"
  end

  desc "Identify A11y tickets in Plane that no longer exist in the report"
  task resolved_violations: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "Report file not found at: #{report_path}"
      return nil
    end

    report = JSON.parse(File.read(report_path), symbolize_names: true)
    violations = report[:unique_violations]

    plane_a11y_tickets = PlaneClient.existing_tickets.select do |ticket|
      ticket["name"].to_s.start_with?("[A11y]")
    end

    report_titles = violations.map { |v| "[A11y] #{v[:rule_id]}: #{v[:selector]}" }

    resolved_tickets = plane_a11y_tickets.reject { |ticket| report_titles.include?(ticket["name"]) }

    if resolved_tickets.empty?
      puts "No resolved tickets found! All Plane [A11y] tickets are still active violations."
    else
      puts "Found #{resolved_tickets.size} RESOLVED violations(s) (resolved in code, still open in Plane):"

      resolved_tickets.each do |ticket|
        puts "  - [#{ticket['name']}](#{ticket['url']})"
      end
    end
  end

  desc "Identify A11y violations in the report that do not exist in Plane yet"
  task new_violations: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "❌ Report file not found at: #{report_path}"
      return nil
    end

    report = JSON.parse(File.read(report_path), symbolize_names: true)
    violations = report[:unique_violations] || []

    existing_titles = PlaneClient.existing_tickets.map { |ticket| ticket["name"].to_s }

    new_report_violations = violations.reject do |v|
      title = "[A11y] #{v[:rule_id]}: #{v[:selector]}"
      existing_titles.include?(title)
    end

    if new_report_violations.empty?
      puts "No new violations found! All report violations already exist in Plane."
    else
      puts "Found #{new_report_violations.size} NEW violation(s) (present in report, not yet in Plane):"

      new_report_violations.each do |v|
        puts "  - [A11y] #{v[:rule_id]}: #{v[:selector]}"
      end
    end
  end

  desc "Count unique accessibility violations from the combined report"
  task unique_violations_count: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "Report not found at #{report_path}"
      next
    end

    report = JSON.parse(File.read(report_path), symbolize_names: true)
    unique_count = report[:summary][:total_unique_violations]

    puts "Total Unique Violations: #{unique_count}"
  end

  desc "Get the count of existing tickets in Plane"
  task existing_tickets_count: :environment do
    tickets = PlaneClient.existing_tickets
    puts "Found #{tickets.size} existing ticket(s) in Plane."
  end

  desc "Get existing tickets in Plane"
  task existing_tickets: :environment do
    PlaneClient.existing_tickets.each do |ticket|
      puts "  - [#{ticket['name']}](#{ticket['url']})"
    end
  end
end
