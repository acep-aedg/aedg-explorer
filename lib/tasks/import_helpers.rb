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
        fips_code = properties['fips_code']

        # Validate presence of fips_code
        if fips_code.blank?
          raise "Missing fips_code for record at index #{index}. Properties: #{properties.inspect}"
        end

        # Ensure geometry is valid and not nil
        if geo_object.nil? || !valid_geometry_types.include?(geo_object.geometry_type.type_name)
          geo_type = geo_object.nil? ? "nil" : geo_object.geometry_type.type_name
          raise "Invalid geometry type '#{geo_type}' at index #{index}. Only #{valid_geometry_types.join(', ')} geometries are allowed."
        end

        # Find or initialize the record based on fips_code
        record = model.find_or_initialize_by(fips_code: fips_code)
        record.assign_aedg_attributes(properties, geo_object)

        if record.save
          puts "Saved #{model.name}: #{record.fips_code}"
        else
          puts "Failed to save #{model.name}: #{fips_code}"
          puts "Errors: #{record.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing #{model.name}: #{fips_code || 'Unknown'} at index #{index}, Error: #{e.message}"
      end
    end

    puts "#{model.name.pluralize} import complete"
  end

  # Imports data from a CSV file into a specified model, allowing for both unique record identification
  # and unconditional record creation.
  #
  # Functionality:
  #   - If `unique_fields` are provided, it finds or initializes records based on those fields.
  #   - If `unique_fields` is empty, it creates a new record for each row.
  #   - If any unique field is blank in a row, that row is skipped with a warning.
  #   - Assigns attributes using `assign_aedg_attributes(properties)`, which must be implemented in the model.
  #
  # Assumptions:
  #   - The model responds to `assign_aedg_attributes(properties)`, which assigns CSV data to attributes.
  #   - If `unique_fields` are provided, they must match CSV column headers.
  #   - The CSV file must have a header row.
  #
  # Parameters:
  #   - filepath (String): The path to the CSV file to be imported.
  #   - model (ActiveRecord::Base): The ActiveRecord model into which data will be imported.
  #   - unique_fields (Array, optional): An array of column names to determine record uniqueness.
  #     - If empty, each row creates a new record.
  #     - If provided, records are found or initialized based on these fields.
  #
  # Example Usage:
  #   - import_csv("data.csv", YourModel, [:name, :year])`
  #     - Finds or initializes records using `name` and `year` as unique identifiers.
  #   - import_csv("data.csv", YourModel)`
  #     - Creates a new record for each row without enforcing uniqueness.
  #     - Relies on the model's validations to prevent duplicate records. 
  
  def self.import_csv(filepath, model, unique_fields = [])
    puts "Importing #{model.name.pluralize} from #{filepath}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      begin
        conditions = {}

        # Only enforce uniqueness if `unique_fields` is provided
        if unique_fields.present?
          unique_fields.each do |field|
            field_value = row[field.to_s].presence
            if field_value.blank?
              warn "Warning: Skipping row #{index} due to missing value for unique field '#{field}'. Row: #{row.to_hash.inspect}"
              next
            end
            conditions[field] = field_value
          end

          # Skip rows where all unique fields are missing
          if conditions.empty?
            warn "Warning: Skipping row #{index} because no unique fields were valid."
            next
          end
        end

        record = unique_fields.present? ? model.find_or_initialize_by(conditions) : model.new
        record.assign_aedg_attributes(row.to_hash)

        message_details = conditions.empty? ? row.to_hash : conditions.inspect
        status = record.save ? "Saved" : "Failed to save"

        puts "#{status} #{model.name}: #{message_details}"
        puts "Errors: #{record.errors.full_messages.join(', ')}" unless record.save     

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
