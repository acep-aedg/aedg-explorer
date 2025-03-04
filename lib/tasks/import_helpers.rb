module ImportHelpers
  def self.import_geojson(filepath, model)
    puts "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
    data = File.read(filepath)
    feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)
    
    feature_collection.each_with_index do |feature, index|
      begin
        properties = feature.properties
        geo_object = feature.geometry

        model.import_aedg_with_geom!(properties, geo_object)
      rescue StandardError => e
        puts "Error processing #{model.name} at index #{index}, Error: #{e.message}"
      end
    end
    puts "#{model.name.pluralize} import complete"
  end

  def self.import_csv(filepath, model)
    puts "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      begin
        model.import_aedg!(row.to_hash)   
      rescue StandardError => e
        puts "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
      end
    end
    puts "#{model.name.pluralize} import complete"
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

        # Validate presence of id field
        if aedg_id.blank?
          raise "Missing id for record at index #{index}: #{row.to_hash}"
        end

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
end
