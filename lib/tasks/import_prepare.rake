require_relative "versioning"

namespace :import do
  desc "Prepare database based on DataPondVersion; truncates/migrates/imports if tag mismatch"
  task prepare: :environment do
    latest_str = DataPondVersion.latest&.current_version
    desired_str = Import::Versioning::DATA_POND_TAG
    force_reimport = ENV["FORCE"] == "true"
    pr_number = ENV.fetch("PR", nil)

    latest = Import::Versioning.to_gem_version(latest_str) if latest_str
    target = Import::Versioning.to_gem_version(desired_str)

    if !force_reimport && (latest == target)
      puts "✅ Data is current (DB=#{latest_str}, desired=#{desired_str}). Nothing to do."
      exit 0
    end

    if pr_number.present?
      puts "🧪 PR detected. Running import of PR ##{pr_number}."
    elsif latest.nil?
      puts "🆕 Initial import to #{desired_str}."
    elsif force_reimport
      puts "🚀 FORCING re-import of #{desired_str} (current DB=#{latest_str || 'nil'})."
    elsif target > latest
      puts "⬆️  Upgrade: #{latest_str} → #{desired_str}."
    else
      puts "⬇️  Rollback: #{latest_str} → #{desired_str} (clean re-seed)."
    end

    puts "🧹 Truncating all tables (rails db:truncate_all)…"

    previous = ENV.fetch("DISABLE_DATABASE_ENVIRONMENT_CHECK", nil)
    ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"

    Rake::Task["db:truncate_all"].reenable
    Rake::Task["db:truncate_all"].invoke
    Rake::Task["storage:clear"].reenable
    Rake::Task["storage:clear"].invoke

    ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = previous

    puts "🧼 Truncate complete."

    Rake::Task["import:all"].reenable
    Rake::Task["import:all"].invoke
    Rake::Task["metadata:import"].reenable
    Rake::Task["metadata:import"].invoke
    
    if pr_number.present?
      puts "✅ Import finished for PR ##{pr_number}."
    else
      puts "✅ Import finished for #{desired_str}."
    end
  end
end
