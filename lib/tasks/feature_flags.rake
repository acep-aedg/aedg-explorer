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
end
