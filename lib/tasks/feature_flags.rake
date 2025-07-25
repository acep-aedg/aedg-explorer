# This task allows you to set, list, and delete feature flags in the database.

# example command to run: bin/rake feature_flag:set[show_extra_datasets,true]
namespace :feature_flag do
  desc 'Set a feature flag (persistent, saved to database)'
  task :set, %i[name state] => :environment do |_, args|
    unless args[:name] && args[:state]
      puts "\n Usage: rake feature_flag:set[feature_name,true|false]\n"
      exit
    end

    FeatureFlag.set(args[:name], args[:state])
    puts "Feature '#{args[:name]}' is now set to: #{args[:state]}"
  end

  # example command to run: bin/rake feature_flag:list
  desc 'List current feature flags'
  task list: :environment do
    puts 'Feature Flags in DB:'
    FeatureFlag.list.each { |k, v| puts "  - #{k}: #{v}" }
  end

  # example command to run: bin/rake feature_flag:delete[feature_name]
  desc 'Delete a feature flag by name'
  task :delete, [:name] => :environment do |_, args|
    unless args[:name]
      puts "\n❗Usage: rake feature_flag:delete[feature_name]\n"
      exit
    end

    flag = FeatureFlag.find_by(name: args[:name])
    if flag
      flag.destroy
      puts "Feature '#{args[:name]}' has been deleted."
    else
      puts "Feature '#{args[:name]}' not found."
    end
  end
end
