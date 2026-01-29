require "fileutils"
require "tmpdir"
require "net/http"
require "uri"
require "yaml"
# Manage feature flags: enable, disable, list, and delete.
#
# Usage:
# bin/rails feature_flag:enable[NAME]
# bin/rails feature_flag:disable[NAME]
# bin/rails feature_flag:list
# bin/rails feature_flag:delete[NAME]
#
# Note: Feature flags are stored in Redis, not in the database.
#
namespace :feature_flag do
  desc "Enable a feature flag"
  task :enable, [:name] => :environment do |_, args|
    name = args[:name] or abort("Usage: rake feature_flag:enable['flag_name']")
    FeatureFlag.enable!(name)
    puts "'#{name}' enabled."
  end

  desc "Disable a feature flag"
  task :disable, [:name] => :environment do |_, args|
    name = args[:name] or abort("Usage: rake feature_flag:disable['flag_name']")
    FeatureFlag.disable!(name)
    puts "'#{name}' disabled."
  end

  desc "List current feature flags in Redis"
  task list: :environment do
    puts "Feature Flags in Redis:"
    FeatureFlag.list.each { |k, v| puts "  - #{k}: #{v}" }
  end

  desc "Delete a feature flag"
  task :delete, [:name] => :environment do |_, args|
    name = args[:name] or abort("Usage: rake feature_flag:delete['flag_name']")
    FeatureFlag.delete(name)
    puts "'#{name}' deleted."
  end
end
