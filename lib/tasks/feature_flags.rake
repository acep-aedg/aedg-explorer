require 'fileutils'
require 'tmpdir'
require 'net/http'
require 'uri'
require 'yaml'
# Manage feature flags: enable, disable, list, and delete.
# Usage: bin/rake feature_flag:enable['flag_name']

namespace :feature_flag do
  desc 'Enable a feature flag'
  task :enable, [:name] => :environment do |_, args|
    name = args[:name]
    unless name
      puts 'Usage: rake feature_flag:enable[\'flag_name\']'
      exit
    end
    FeatureFlag.enable!(name)
    puts "'#{name}' enabled."
  end

  desc 'Disable a feature flag'
  task :disable, [:name] => :environment do |_, args|
    name = args[:name]
    unless name
      puts 'Usage: rake feature_flag:disable[\'flag_name\']'
      exit
    end
    FeatureFlag.disable!(name)
    puts "'#{name}' disabled."
  end

  desc 'List current feature flags'
  task list: :environment do
    puts 'Feature Flags in DB:'
    FeatureFlag.list.each { |k, v| puts "  - #{k}: #{v}" }
  end

  desc 'Delete a feature flag'
  task :delete, [:name] => :environment do |_, args|
    name = args[:name]
    unless name
      puts 'Usage: rake feature_flag:delete[\'flag_name\']'
      exit
    end

    flag = FeatureFlag.find_by(name: name)
    if flag
      flag.destroy
      puts "'#{name}' deleted."
    else
      puts "'#{name}' not found."
    end
  end

  desc 'Download feature_flags_backup.yml from GitHub (supports private repos) and restore into DB'
  task pull_from_gh: :environment do
    url = ENV['FEATURE_FLAG_FILE_URL']
    token = ENV['GITHUB_TOKEN']

    raise '❌ FEATURE_FLAG_FILE_URL not set!' if url.blank?
    raise '❌ GITHUB_TOKEN not set!' if token.blank?

    puts "📥 Downloading feature flags from: #{url}"

    # Use curl so it works for private repos too
    response = `curl -s -H "Authorization: token #{token}" "#{url}"`
    if response.blank?
      raise '❌ No response from GitHub. Check URL/token permissions.'
    end

    flags = YAML.safe_load(response) || []
    if flags.empty?
      puts '⚠️  No flags found in YAML.'
      next
    end

    flags.each do |flag|
      rec = FeatureFlag.find_or_initialize_by(name: flag['name'])
      rec.state = flag['state']
      rec.save!
    end

    puts "✅ Restored #{flags.size} feature flags."
  end

  desc 'Dump current feature flags to config/feature_flags_backup.yml'
  task dump_to_file: :environment do
    flags = FeatureFlag.all.map { |f| { 'name' => f.name, 'state' => f.state } }

    path = Rails.root.join('config/feature_flags_backup.yml')
    File.write(path, flags.to_yaml)

    puts "✅ Dumped #{flags.size} feature flags to '#{path}'"
  end
end
