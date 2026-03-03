module ImportHelpers
  class << self
    # Imports geographic data from a GeoJSON file and processes it into the given model.
    # It assumes there is an `import_aedg_with_geom!` method for the given model to store the data.
    def import_geojson(filepath, model)
      return unless file_exists?(filepath, model)

      start_time = Time.current
      puts "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
      data = File.read(filepath)
      feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)

      feature_collection.each_with_index do |feature, index|
        properties = feature.properties
        geo_object = feature.geometry

        model.import_aedg_with_geom!(properties, geo_object)
      rescue StandardError => e
        puts "Error processing #{model.name} at index #{index}, Error: #{e.message}"
      end
      duration = (Time.current - start_time).round(2)
      puts "#{model.name.pluralize} complete: #{duration}s"
    end

    # Batch imports geographic data from a GeoJSON file and processes it into the given model.
    # It assumes there is an `build_from_aedg_geojson` method for the given model to store the data.
    def batch_import_geojson(filepath, model)
      return unless file_exists?(filepath, model)

      start_time = Time.current
      puts "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."

      begin
        data = File.read(filepath)
        feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)

        records = feature_collection.map do |feature|
          model.build_from_aedg_geojson(feature.properties, feature.geometry)
        rescue StandardError => e
          puts "  ⚠️ Skipping a row in #{model.name}: #{e.message}"
          nil
        end.compact

        result = model.import records,
                              batch_size: 1000,
                              track_validation_failures: true

        failed_instances = result.failed_instances
        duration = (Time.current - start_time).round(2)
        print_summary(model, records.size, failed_instances.size, duration)
        report_errors(failed_instances) if failed_instances.any?
      rescue StandardError => e
        puts "Error processing #{model.name}: #{e.class} - #{e.message}"
      end
    end

    # Batch imports tabular data from a CSV file and processes it into the given model.
    # It assumes there is an `build_from_aedg` method for the given model to store the data.
    def batch_import_csv(filepath, model)
      return unless file_exists?(filepath, model)

      start_time = Time.current
      puts "Importing #{model.name.pluralize}..."

      records = []
      CSV.foreach(filepath, headers: true) do |row|
        records << model.build_from_aedg(row.to_hash)
      end

      result = model.import records,
                            batch_size: 2000,
                            recursive: true,
                            track_validation_failures: true

      failed_instances = result.failed_instances
      duration = (Time.current - start_time).round(2)
      print_summary(model, records.size, failed_instances.size, duration)
      report_errors(failed_instances) if failed_instances.any?
    end

    def ensure_empty!(model, delete_tasks)
      return unless model.any?

      human_name = model.name.titleize
      tasks = Array(delete_tasks)
      command_chain = tasks.map { |t| "rails delete:#{t}" }.join(" && ")

      raise <<~ERROR
        \n ERROR: #{human_name} table is not empty!
        To clear it safely, run:
            #{command_chain}
        Then try the import again.\n
      ERROR
    end

    private

    def file_exists?(filepath, model)
      return true if File.exist?(filepath)

      puts "⚠️  SKIPPING #{model.name}: File not found at #{filepath}"
      false
    end

    def print_summary(model, total, failed, duration)
      puts "--------------------------------------------------"
      puts "✅ #{model.name.pluralize} complete!"
      puts "Total Records: #{total} | Failed Records: #{failed} | Time: #{duration}s"
    end

    def report_errors(failed_instances)
      return if failed_instances.empty?

      puts "\nERROR REPORT:"
      failed_instances.each do |index_in_array, instance|
        puts "CSV Row #: #{index_in_array + 2}"
        puts "Row Data: #{instance.attributes.compact}"
        puts "Validation Errors: #{instance.errors.full_messages.join(', ')}"
        puts "---"
      end
    end
  end
end
