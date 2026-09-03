module ImportHelpers
  class << self
    def with_import_banner(msg)
      status = Kredis.string "aedg:import_status"
      status.value = msg

      Turbo::StreamsChannel.broadcast_replace_to(
        "import_status",
        target: "import-banner-container",
        partial: "shared/import_banner"
      )

      yield
    ensure
      status.del
      Turbo::StreamsChannel.broadcast_replace_to(
        "import_status",
        target: "import-banner-container",
        partial: "shared/import_banner"
      )
    end

    # Imports geographic data from a GeoJSON file and processes it into the given model.
    # It assumes there is an `import_aedg_with_geom!` method for the given model to store the data.
    def import_geojson(filepath, model)
      return unless file_exists?(filepath, model)

      ensure_empty!(model)
      start_time = Time.current
      puts "📂 Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
      data = File.read(filepath)
      feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)

      feature_collection.each_with_index do |feature, index|
        properties = feature.properties
        geo_object = feature.geometry

        model.import_aedg_with_geom!(properties, geo_object)
      rescue StandardError => e
        puts "❗Error processing #{model.name} at row #{index + 2}: #{e.class} - #{e.message}"
      end
      duration = (Time.current - start_time).round(2)
      puts "✅ #{model.name.pluralize} complete: #{duration}s"
    end

    # Batch imports geographic data from a GeoJSON file and processes it into the given model.
    # It assumes there is an `build_from_aedg_geojson` method for the given model to store the data.
    def batch_import_geojson(filepath, model)
      return unless file_exists?(filepath, model)

      ensure_empty!(model)
      start_time = Time.current
      puts "📂 Importing #{model.name.pluralize} from #{File.basename(filepath)}..."

      begin
        data = File.read(filepath)
        feature_collection = RGeo::GeoJSON.decode(data, json_parser: :json)

        records = feature_collection.map do |feature|
          model.build_from_aedg_geojson(feature.properties, feature.geometry)
        end

        result = model.import records,
                              batch_size: 2000,
                              track_validation_failures: true

        failed_instances = result.failed_instances
        duration = (Time.current - start_time).round(2)
        print_summary(model, records.size, failed_instances.size, duration)
        print_errors(failed_instances) if failed_instances.any?
      rescue StandardError => e
        puts "❗ Error processing #{model.name}: #{e.class} - #{e.message}"
      end
    end

    # Batch imports tabular data from a CSV file and processes it into the given model.
    # It assumes there is an `build_from_aedg` method for the given model to store the data.
    def batch_import_csv(filepath, model)
      return unless file_exists?(filepath, model)

      ensure_empty!(model)
      start_time = Time.current
      puts "📂 Importing #{model.name.pluralize} from #{File.basename(filepath)}..."

      begin
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
        print_errors(failed_instances) if failed_instances.any?
      rescue StandardError => e
        puts "❗ Error processing #{model.name}: #{e.class} - #{e.message}"
      end
    end

    def ensure_empty!(model)
      return unless model.any?

      task = "delete:#{model.table_name}"
      msg = if Rake::Task.task_defined?(task)
              "Run: rails #{task}\nThen try again."
            else
              "No delete task found. Run: rails import:prepare FORCE=true"
            end

      raise "\n ❗ ERROR: #{model.name.titleize} table is not empty!\n#{msg}\n\n"
    end

    private

    def file_exists?(filepath, model)
      return true if File.exist?(filepath)

      puts "⚠️ SKIPPING #{model.name}: File not found at #{filepath}"
      false
    end

    def print_summary(model, total, failed, duration)
      puts "✅ #{model.name.pluralize} complete! | Total Records: #{total} | Failed Records: #{failed} | Time: #{duration}s"
    end

    def print_errors(failed_instances)
      puts "\n❗ERROR REPORT:"
      failed_instances.each do |index_in_array, instance|
        puts "CSV Row #: #{index_in_array + 2}"
        puts "Row Data: #{instance.attributes.compact}"
        puts "Validation Errors: #{instance.errors.full_messages.join(', ')}"
        puts "--------------------------------------------------"
      end
    end
  end
end
