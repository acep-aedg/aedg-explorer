namespace :import do
  desc "Import Community Data from .geojson file"
  task communities: :environment do
    require 'json'

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

        # Assign attributes from the JSON properties
        community.assign_attributes(
          name: properties['name'],
          latitude: properties['latitude'],
          longitude: properties['longitude'],
          ansi_code: properties['ansi_code'],
          community_id: properties['community_id'],
          global_id: properties['global_id']
        )

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
