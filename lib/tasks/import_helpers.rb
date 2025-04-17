module ImportHelpers

# Imports geographic data from a GeoJSON file and processes it into the given model.
# It assumes there is an `import_aedg_with_geom!` method for the given model to store the data.
  def self.import_geojson(filepath, model)
    Rails.logger.info "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
    data = File.read(filepath)
    feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)
    
    feature_collection.each_with_index do |feature, index|
      begin
        properties = feature.properties
        geo_object = feature.geometry

        model.import_aedg_with_geom!(properties, geo_object)
      rescue StandardError => e
        Rails.logger.info "Error processing #{model.name} at index #{index}, Error: #{e.message}"
      end
    end
    Rails.logger.info "#{model.name.pluralize} import complete"
  end

# Imports tabular data from a CSV file and processes it into the given model.
# It assumes there is an `import_aedg!` method for the given model to store the data.
  def self.import_csv(filepath, model)
    Rails.logger.info "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      begin
        model.import_aedg!(row.to_hash)   
      rescue StandardError => e
        Rails.logger.info "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
      end
    end
    Rails.logger.info "#{model.name.pluralize} import complete"
  end
end
