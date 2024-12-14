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
end
