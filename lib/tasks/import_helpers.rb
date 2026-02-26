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

    # Imports tabular data from a CSV file and processes it into the given model.
    # It assumes there is an `import_aedg!` method for the given model to store the data.
    def import_csv(filepath, model)
      return unless file_exists?(filepath, model)

      start_time = Time.current
      puts "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
      csv = CSV.read(filepath, headers: true)

      csv.each_with_index do |row, index|
        model.import_aedg!(row.to_hash)
      rescue StandardError => e
        puts "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
      end
      duration = (Time.current - start_time).round(2)
      puts "#{model.name.pluralize} complete: #{duration}s"
    end

    # Imports tabular data from a CSV file and processes it into the given model in batches.
    # It assumes there is an `build_from_aedg` method for the given model to store the data.
    def import_csv_batch(filepath, model)
      return unless file_exists?(filepath, model)

      start_time = Time.current
      puts "Importing #{model.name.pluralize}..."

      records = []
      CSV.foreach(filepath, headers: true) do |row|
        records << model.build_from_aedg(row.to_hash)
      end

      result = model.import records,
                            batch_size: 2000,
                            batch_progress: progress_reporter,
                            track_validation_failures: true

      failed_instances = result.failed_instances
      duration = (Time.current - start_time).round(2)
      print_summary(model, records.size, failed_instances.size, duration)
      report_errors(failed_instances) if failed_instances.any?
    end

    def download_data(remote_path, local_path)
      repo_url = ENV.fetch("GH_DATA_REPO_URL", "https://github.com/acep-aedg/aedg-data-pond")

      # --- 1. Determine Source (PR, Branch, Tag) ---
      if ENV["PR"].present?
        pr_number = ENV["PR"]
        puts "⚠️  PR detected! Preparing to fetch Pull Request ##{pr_number}..."

        fetch_cmd    = "git fetch origin pull/#{pr_number}/head:pr-#{pr_number}"
        checkout_cmd = "git checkout pr-#{pr_number}"
        source_name  = "PR ##{pr_number}"

      elsif ENV["BRANCH"].present?
        branch = ENV["BRANCH"]
        puts "⚠️  Branch detected! Preparing to fetch Branch '#{branch}'..."

        fetch_cmd    = "git fetch origin #{branch}"
        checkout_cmd = "git checkout -B #{branch} origin/#{branch}"
        source_name  = "Branch '#{branch}'"
      else
        tag = Import::Versioning::DATA_POND_TAG
        # Quick check to ensure tag exists
        tag_exists = system("git ls-remote --tags #{repo_url} refs/tags/#{tag} | grep #{tag}")
        raise "Error: Tag '#{tag}' not found in repo #{repo_url}" unless tag_exists

        fetch_cmd    = "git fetch --tags"
        checkout_cmd = "git checkout tags/#{tag} -b temp-tag-branch"
        source_name  = "Tag #{tag}"
      end

      # --- 2. Setup Local Directory ---
      FileUtils.mkdir_p(local_path)
      # Create .keep file to ensure git keeps the folder
      FileUtils.touch(File.join(local_path, ".keep"))

      # --- 3. Execute Git Operations ---
      Dir.mktmpdir do |temp_dir|
        puts "⬇️  Cloning repository..."
        # Clone without checking out files yet (faster)
        system("git clone --no-checkout #{repo_url} #{temp_dir}") or raise "Failed to clone #{repo_url}"

        Dir.chdir(temp_dir) do
          puts "🔄 Fetching ref..."
          system(fetch_cmd) or raise "Failed to fetch #{source_name}"

          puts "Checking out #{source_name}..."
          system(checkout_cmd) or raise "Failed to checkout #{source_name}"

          # Enable sparse-checkout (Optimization: only download specific folder)
          system("git sparse-checkout init --cone")
          system("git sparse-checkout set #{remote_path}")

          # Sync files
          puts "📂 Syncing #{remote_path} to #{local_path}..."
          system("rsync -av --delete --exclude='metadata' --exclude='.keep' #{remote_path}/ #{local_path}/")
        end
      end

      puts "✅ Download complete! #{source_name} files copied to #{local_path}."
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

    def progress_reporter
      lambda { |_size, num_batches, current, duration|
        percent = ((current.to_f / num_batches) * 100).round(1)
        puts "Batch #{current}/#{num_batches} (#{percent}%) - #{duration}s"
      }
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
