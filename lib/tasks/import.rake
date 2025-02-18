require 'csv'
require 'rgeo/geo_json'

namespace :import do
  desc "Import Data Files into the Database"
  task all: :environment do
    Rake::Task['import:pull_google_drive'].invoke
    Rake::Task['import:communities'].invoke
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
    community_data = File.read(filepath)
    feature_collection = RGeo::GeoJSON.decode(community_data, json_parser: :json)

    feature_collection.each_with_index do |feature, index|
      begin
        properties = feature.properties
        geo_object = feature.geometry

        # Validate presence of fips_code
        if properties['fips_code'].blank?
          raise "Missing fips_code for record at index #{index}. Properties: #{properties.inspect}"
        end

        # Ensure it's a valid Point and not nil
        if geo_object.nil? || geo_object.geometry_type.type_name != "Point"
          geo_type = geo_object.nil? ? "nil" : geo_object.geometry_type.type_name
          raise "Invalid geometry type '#{geo_type}' at index #{index}. Only 'Point' geometry is allowed."
        end

        # Find or initialize the community based on fips_code
        community = Community.find_or_initialize_by(fips_code: properties['fips_code'])
        community.assign_aedg_attributes(properties, geo_object)

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
end
