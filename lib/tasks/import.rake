require 'json'
require 'csv'

namespace :import do
  desc "Import Data Files into the Database"
  task all: :environment do
    Rake::Task['import:pull_github_files'].invoke
    Rake::Task['import:communities'].invoke
  end

  desc "Import only the data files from a specific GitHub folder"
  task pull_github_files: :environment do
    repo_url = ENV['GH_DATA_REPO_URL']
    folder_path = "data/final"
    local_dir = "db/imports"

    puts "Fetching files from GitHub repo: #{repo_url}, folder: #{folder_path}"

    # Create a temporary directory to clone the repo
    temp_dir = "tmp_repo"

    puts "Cloning repository..."
    system("git clone --no-checkout #{repo_url} #{temp_dir}")
    
    Dir.chdir(temp_dir) do
      # Enable sparse-checkout
      unless File.exist?(".git/info/sparse-checkout")
        system("git sparse-checkout init --cone")
        system("git sparse-checkout set #{folder_path}")
        system("git checkout")
      end

      # Sync only new/updated files from `data/final/` to `db/imports/`
      system("rsync -av --update --exclude='*.md' #{folder_path}/ ../#{local_dir}/")
    end

    # Remove temporary repo
    FileUtils.rm_rf(temp_dir)

    puts "Import complete! Only new/updated files copied to #{local_dir}."
  end

  desc "Import Community Data from .geojson file"
  task communities: :environment do

    filepath = Rails.root.join('db', 'imports', 'communities.geojson')
    file = File.read(filepath)
    communities_data = JSON.parse(file)

    communities_data['features'].each_with_index do |feature, index|
      properties = feature['properties']

      begin

        # Validate presence of fips_code
        if properties['fips_code'].blank?
          raise "Missing fips_code for record at index #{index}. Properties: #{properties.inspect}"
        end
        
        # Find or initialize the community based on fips_code
        community = Community.find_or_initialize_by(fips_code: properties['fips_code'])
        community.assign_aedg_attributes(properties)

        if community.save
          puts "Saved Community: #{community.name}"
        else
          puts "Failed to save Community: #{properties['name']}"
          puts "Errors: #{community.errors.full_messages.join(', ')}"
        end

      rescue StandardError => e
        puts "Error processing Community: #{properties['name'] || 'Unknown'} at index #{index}, Error: #{e.message}"
      end
    end
    puts "Communities imported successfully!"
  end
end
