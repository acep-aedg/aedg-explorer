module ImportHelpers
  # Imports geographic data from a GeoJSON file into a specified model.
  # 
  # Assumptions:
  #   - The model has a method `assign_aedg_attributes(properties, geo_object)`.
  #   - The model has a `fips_code` attribute that uniquely identifies records.
  #   - The GeoJSON contains a `FeatureCollection` where:
  #     - `properties` include a `fips_code`.
  #     - `geometry` must be a valid type from `valid_geometry_types`.
  def self.import_geojson_with_fips(filepath, model, valid_geometry_types)
    puts "Importing #{model.name.pluralize} from #{filepath}..."
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

  # Imports data from a CSV file into a specified model using `community_fips_code` as the unique identifier.
  #
  # Assumptions:
  #   - The model has a method `assign_aedg_attributes(properties)`.
  #   - The model has a `community_fips_code` attribute for uniquely identifying records.
  #   - The CSV contains a `community_fips_code` column.
  def self.import_csv_with_fips(filepath, model)
    puts "Importing #{model.name.pluralize} from #{filepath}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      begin
        community_fips_code = row["community_fips_code"]
        next if community_fips_code.blank?

        record = model.find_or_initialize_by(community_fips_code: community_fips_code)
        record.assign_aedg_attributes(row.to_hash)

        if record.save
          puts "Saved #{model.name}: #{record.community_fips_code}"
        else
          puts "Failed to save #{model.name}: #{row['community_fips_code']}"
          puts "Errors: #{record.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
      end
    end
  end

  # This function imports data from a CSV file into a specified model and associates/maps it with an `AedgImport` record.
  # Assumptions:
  #   - The model has a method `import_aedg_attributes(properties)` that initializes a new record.
  #   - The CSV contains an "id" column, which represents an external identifier (`aedg_id`).
  #   - The `id` from the CSV is stored in `aedg_imports.aedg_id` to maintain external ID references.
  def self.import_csv_with_id(filepath, model)
    puts "Importing #{model.name.pluralize} from #{filepath}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      begin
        aedg_id = row["id"]
        next if aedg_id.blank?

        record = model.import_aedg_attributes(row.to_hash)

        if record.save
          puts "Saved #{model.name}: #{record.aedg_id}"
        else
          puts "Failed to save #{model.name}: #{row['id']}"
          puts "Errors: #{record.errors.full_messages.join(', ')}"
        end
      rescue StandardError => e
        puts "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
      end
    end
  end

  # This function imports data from a CSV file into a specified model.
  # Assumptions:
  #   - The model has a method `import_aedg_attributes(properties)` that assigns attributes to a new record.
  def self.import_csv(filepath, model)
    puts "Importing #{model.name.pluralize} from #{filepath}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      begin
        record = model.new
        record.assign_aedg_attributes(row.to_hash)

        if record.save
          puts "Saved #{model.name}: #{record.id}"
        else
          puts "Failed to save #{model.name}: #{row.to_hash}"
          puts "Errors: #{record.errors.full_messages.join(', ')}"
        end
      rescue StandardError => e
        puts "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
      end
    end
  end
end