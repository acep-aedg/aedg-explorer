module ImportHelpers
  def self.import_geojson(filepath, model, valid_geometry_types)
    data = File.read(filepath)
    feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)

    feature_collection.each_with_index do |feature, index|
      begin
        properties = feature.properties
        geo_object = feature.geometry

        # Validate presence of fips_code
        if properties['fips_code'].blank?
          raise "Missing fips_code for record at index #{index}. Properties: #{properties.inspect}"
        end

        # Ensure geometry is valid and not nil
        if geo_object.nil? || !valid_geometry_types.include?(geo_object.geometry_type.type_name)
          geo_type = geo_object.nil? ? "nil" : geo_object.geometry_type.type_name
          raise "Invalid geometry type '#{geo_type}' at index #{index}. Only #{valid_geometry_types.join(', ')} geometries are allowed."
        end

        # Find or initialize the record based on fips_code
        record = model.find_or_initialize_by(fips_code: properties['fips_code'])
        record.assign_aedg_attributes(properties, geo_object)

        if record.save
          puts "Saved #{model.name}: #{record.name}"
        else
          puts "Failed to save #{model.name}: #{properties['name']}"
          puts "Errors: #{record.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing #{model.name}: #{properties['name'] || 'Unknown'} at index #{index}, Error: #{e.message}"
      end
    end

    puts "#{model.name.pluralize} imported successfully!"
  end
end