require "plane_client"
require "json"
require "cgi"

namespace :plane do
  desc "Parse combined accessibility report JSON and create Plane tickets"
  task create_a11y_tickets: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "❌ Report file not found at: #{report_path}"
      next
    end

    report = JSON.parse(File.read(report_path))
    violations = report["unique_violations"] || []

    existing_tickets = PlaneClient.existing_tickets
    existing_titles = existing_tickets.pluck("name")
    puts "ℹ️  Found #{existing_titles.size} existing tickets in project."
    puts "ℹ️  Found #{violations.size} in the report."

    violations.each_with_index do |v, idx|
      title = "[A11y] #{v['rule_id']}: #{v['selector']}"

      if existing_titles.include?(title)
        puts "⏭️  ([#{idx + 1}/#{violations.size}]) Skipping duplicate: #{title}"
        next
      end

      description_html = PlaneClient.build_work_item_description(v)

      puts "🚀 ([#{idx + 1}/#{violations.size}]) Creating ticket: #{title}..."

      PlaneClient.create_work_item(
        name: title,
        description_html: description_html,
        impact: v["impact"],
        labels: [""]
      )

      # Pause between requests to prevent connection throttling
      sleep 1.0
    end

    puts "🎉 Successfully synced all violations to Plane!"
  end

  desc "Identify A11y tickets in Plane that no longer exist in the report"
  task get_resolved_violations: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "❌ Report file not found at: #{report_path}"
      return nil
    end

    report = JSON.parse(File.read(report_path))
    violations = report["unique_violations"] || []

    plane_a11y_titles = PlaneClient.existing_tickets.map { |ticket| ticket["name"] }.select { |title| title.start_with?("[A11y]") }

    report_titles = violations.map { |v| "[A11y] #{v['rule_id']}: #{v['selector']}" }

    # resolved = in Plane, but NO LONGER in the report
    resolved_titles = plane_a11y_titles - report_titles

    puts "\n--------------------------------------------------"
    if resolved_titles.empty?
      puts "✅ No resolved tickets found! All Plane [A11y] tickets are still active violations."
    else
      puts "🧹 Found #{resolved_titles.size} resolved ticket(s) (resolved in code, still open in Plane):"
      resolved_titles.each { |title| puts "  - #{title}" }
    end
    puts "--------------------------------------------------\n"

    resolved_titles.size
  end

  desc "Identify new A11y violations that have not been synced to Plane yet"
  task get_new_violations: :environment do
    report_path = Rails.root.join("tmp/axe-results/combined_report.json")

    unless File.exist?(report_path)
      puts "❌ Report file not found at: #{report_path}"
      return nil
    end

    report = JSON.parse(File.read(report_path))
    violations = report["unique_violations"] || []

    plane_a11y_titles = PlaneClient.existing_tickets.map { |ticket| ticket["name"] }.select { |title| title.start_with?("[A11y]") }

    new_violations = violations.reject do |v|
      title = "[A11y] #{v['rule_id']}: #{v['selector']}"
      plane_a11y_titles.include?(title)
    end

    if new_violations.empty?
      puts "✅ No new violations found! Plane is completely up to date."
    else
      puts "🚨 Found #{new_violations.size} NEW violation(s) missing from Plane:"
      new_violations.each do |v|
        puts "  - [A11y] #{v['rule_id']}: #{v['selector']}"
      end
    end

    new_violations.size
  end

  desc 'Count unique accessibility violations from the combined report'
  task get_unique_violations: :environment do
    report_path = Rails.root.join('tmp/axe-results/combined_report.json')

    unless File.exist?(report_path)
      puts "Report not found at #{report_path}"
      next
    end

    report = JSON.parse(File.read(report_path), symbolize_names: true)
    unique_count = Array(report[:unique_violations]).size

    puts "Total Unique Violations: #{unique_count}"

    unique_count
  end

  desc "Get the count of existing tickets in Plane"
    task get_existing_tickets_count: :environment do
      tickets = PlaneClient.existing_tickets
      count = tickets.size
  
      puts "📋 Found #{count} existing ticket(s) in Plane."
  
      count
    end
end
