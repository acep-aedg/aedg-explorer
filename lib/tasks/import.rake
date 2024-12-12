namespace :import do
  desc "Import Community Data from .geojson file"
  task communities: :environment do
    require 'json'

    filepath = Rails.root.join('db', 'seeds', 'communities.geojson')
    file = File.read(filepath)
    communities_data = JSON.parse(file)

    communities_data['features'].each do |feature|
      properties = feature['properties']
      # Print each property value
      puts "ID: #{properties['id']}"
      puts "Community Name: #{properties['name']}"
      puts "Community Type ID: #{properties['incorporation_id']}"
      puts "Community Type Name: #{properties['incorporation']}"
      puts "Latitude: #{properties['latitude']}"
      puts "Longitude: #{properties['longitude']}"
      puts "Global ID: #{properties['global_id']}"
      puts "-----------------------------"
    end

    puts "Communities imported successfully!"
  end
  
end
