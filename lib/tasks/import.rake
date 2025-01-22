require 'json'
require 'csv'

namespace :import do
  desc "Import Data Files into the Database"
  task all: :environment do
    Rake::Task['import:pull_google_drive'].invoke
    Rake::Task['import:communities'].invoke
    Rake::Task['import:populations'].invoke
  end

  desc "Import Data Files from Google Drive via rclone"
  task pull_google_drive: :environment do
    puts "Updating import files from Google Drive..."
    success = system("rclone copy -v aedg-db-imports:/ db/imports")

    if success
      puts "Import files updated successfully!"
    else
      puts "Failed to update import files from Google Drive."
      exit 1
    end
  end

  desc "Import Community Data from .geojson file"
  task communities: :environment do

    filepath = Rails.root.join('db', 'imports', 'communities.geojson')
    file = File.read(filepath)
    communities_data = JSON.parse(file)

    communities_data['features'].each_with_index do |feature, index|
      properties = feature['properties']

      begin

        # Validate presence of fips_code
        if properties['fips_code'].blank?
          raise "Missing fips_code for record at index #{index}. Properties: #{properties.inspect}"
        end
        
        # Find or initialize the community based on fips_code
        community = Community.find_or_initialize_by(fips_code: properties['fips_code'])
        community.assign_aedg_attributes(properties)

        if community.save
          puts "Saved Community: #{community.name}"
        else
          puts "Failed to save Community: #{properties['name']}"
          puts "Errors: #{community.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing Community: #{properties['name'] || 'Unknown'} at index #{index}, Error: #{e.message}"
      end
    end
    puts "Communities imported successfully!"
  end

  desc "Import Population Data from .csv file"
  task populations: :environment do
    filepath = Rails.root.join('db', 'imports', 'populations.csv')
    populations_data = CSV.read(filepath, headers: true)

    populations_data.each_with_index do |row, index|
      begin
        # Validate presence of fips_code
        if row['fips_code'].blank?
          raise "Missing fips_code for record at index #{index}. Row: #{row.inspect}"
        end

        # Find or initialize the population based on fips_code
        population = Population.find_or_initialize_by(fips_code: row['fips_code'])
        population.assign_attributes(row.to_h)

        if population.save
          puts "Saved Population for: #{population.fips_code}"
          
        else
          puts "Failed to save Population for: #{population.fips_code}"
          puts "Errors: #{population.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing Population for: #{row['fips_code'] || 'Unknown'} at index #{index}, Error: #{e.message}"
      end
    end
  end
end
