module ImportHelpers
  # Imports geographic data from a GeoJSON file and processes it into the given model.
  # It assumes there is an `import_aedg_with_geom!` method for the given model to store the data.
  def self.import_geojson(filepath, model)
    unless File.exist?(filepath)
      puts "⚠️  SKIPPING #{model.name}: File not found at #{filepath}"
      return
    end

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
    puts "#{model.name.pluralize} import complete"
  end

  # Imports tabular data from a CSV file and processes it into the given model.
  # It assumes there is an `import_aedg!` method for the given model to store the data.
  def self.import_csv(filepath, model)
    unless File.exist?(filepath)
      puts "⚠️  SKIPPING #{model.name}: File not found at #{filepath}"
      return
    end

    puts "Importing #{model.name.pluralize} from #{File.basename(filepath)}..."
    csv = CSV.read(filepath, headers: true)

    csv.each_with_index do |row, index|
      model.import_aedg!(row.to_hash)
    rescue StandardError => e
      puts "Error processing #{model.name || 'Unknown'} at index #{index}: #{e.message}"
    end
    puts "#{model.name.pluralize} import complete"
  end

  def self.download_data(remote_path, local_path)
    repo_url = ENV.fetch('GH_DATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')

    # --- 1. Determine Source (PR vs Tag) ---
    if ENV['PR'].present?
      pr_number = ENV['PR']
      puts "⚠️  PR detected! Preparing to fetch Pull Request ##{pr_number}..."

      fetch_cmd    = "git fetch origin pull/#{pr_number}/head:pr-#{pr_number}"
      checkout_cmd = "git checkout pr-#{pr_number}"
      source_name  = "PR ##{pr_number}"
    else
      tag = Import::Versioning::DATA_POND_TAG
      # Quick check to ensure tag exists
      tag_exists = system("git ls-remote --tags #{repo_url} refs/tags/#{tag} | grep #{tag}")
      raise "Error: Tag '#{tag}' not found in repo #{repo_url}" unless tag_exists

      fetch_cmd    = 'git fetch --tags'
      checkout_cmd = "git checkout tags/#{tag} -b temp-tag-branch"
      source_name  = "Tag #{tag}"
    end

    # --- 2. Setup Local Directory ---
    FileUtils.mkdir_p(local_path)
    # Create .keep file to ensure git keeps the folder
    FileUtils.touch(File.join(local_path, '.keep'))

    # --- 3. Execute Git Operations ---
    Dir.mktmpdir do |temp_dir|
      puts '⬇️  Cloning repository...'
      # Clone without checking out files yet (faster)
      system("git clone --no-checkout #{repo_url} #{temp_dir}") or raise "Failed to clone #{repo_url}"

      Dir.chdir(temp_dir) do
        puts '🔄 Fetching ref...'
        system(fetch_cmd) or raise "Failed to fetch #{source_name}"

        puts "Checking out #{source_name}..."
        system(checkout_cmd) or raise "Failed to checkout #{source_name}"

        # Enable sparse-checkout (Optimization: only download specific folder)
        system('git sparse-checkout init --cone')
        system("git sparse-checkout set #{remote_path}")

        # Sync files
        puts "📂 Syncing #{remote_path} to #{local_path}..."
        system("rsync -av --delete --exclude='metadata' --exclude='.keep' #{remote_path}/ #{local_path}/")
      end
    end

    puts "✅ Download complete! #{source_name} files copied to #{local_path}."
  end
end
