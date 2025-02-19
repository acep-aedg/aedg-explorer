require 'csv'
require 'rgeo/geo_json'

namespace :import do
  desc "Import Data Files into the Database"
  task all: :environment do
    Rake::Task['import:pull_github_files'].invoke
    Rake::Task['import:boroughs'].invoke
    Rake::Task['import:communities'].invoke
  end

  desc "Import only the data files from a specific GitHub folder"
  task pull_github_files: :environment do
    repo_url = ENV['GH_DATA_REPO_URL']
    folder_path = "data/final"
    local_dir = Rails.root.join("db", "imports").to_s 

    puts "Fetching files from GitHub repo: #{repo_url}, folder: #{folder_path}"

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, ".keep")
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    # Create a temporary directory
    Dir.mktmpdir do |temp_dir|
      system("git clone --no-checkout #{repo_url} #{temp_dir}")

      Dir.chdir(temp_dir) do
        # Enable sparse-checkout
        unless File.exist?(".git/info/sparse-checkout")
          system("git sparse-checkout init --cone")
          system("git sparse-checkout set #{folder_path}")
          system("git checkout")
        end

        # Sync only new/updated files from `data/final/` to `db/imports/`
        system("rsync -av --update --exclude='*.md' #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Import complete! Only new/updated files copied to #{local_dir}."
  end

  desc "Import Borough Data from .geojson file"
  task boroughs: :environment do
    filepath = Rails.root.join('db', 'imports', 'boroughs.geojson')
    borough_data = File.read(filepath)
    feature_collection = RGeo::GeoJSON.decode(borough_data, json_parser: :json)

    feature_collection.each_with_index do |feature, index|
      begin
        properties = feature.properties
        geo_object = feature.geometry
        

        # Validate presence of fips_code
        if properties['fips_code'].blank?
          raise "Missing fips_code for record at index #{index}. Properties: #{properties.inspect}"
        end

        # Ensure it's a valid geometry and not nil
        valid_types = [ "Polygon", "MultiPolygon" ]

        if geo_object.nil? || !valid_types.include?(geo_object.geometry_type.type_name)
          geo_type = geo_object.nil? ? "nil" : geo_object.geometry_type.type_name
          raise "Invalid geometry type '#{geo_type}' at index #{index}. Only #{valid_types.join(', ')} geometries are allowed."
        end

        # Find or initialize the borough based on fips_code
        borough = Borough.find_or_initialize_by(fips_code: properties['fips_code'])
        borough.assign_aedg_attributes(properties, geo_object)

        if borough.save
          puts "Saved Borough: #{borough.name}"
        else
          puts "Failed to save Borough: #{properties['name']}"
          puts "Errors: #{borough.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing Borough: #{properties['name'] || 'Unknown'} at index #{index}, Error: #{e.message}"
      end
    end
    puts "Boroughs imported successfully!"
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
