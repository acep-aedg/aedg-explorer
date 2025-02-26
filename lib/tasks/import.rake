require 'csv'
require 'rgeo/geo_json'
require_relative 'import_helpers'

namespace :import do
  desc "Import Data Files into the Database"
  task all: :environment do
    Rake::Task['import:pull_github_files'].invoke
    Rake::Task['import:boroughs'].invoke
    Rake::Task['import:regional_corporations'].invoke
    Rake::Task['import:communities'].invoke
    Rake::Task['import:populations'].invoke
    Rake::Task['import:transportation'].invoke
  end

  desc "Import only the data files from a specific GitHub folder"
  task pull_github_files: :environment do
    repo_url = ENV['GH_DATA_REPO_URL']
    folder_path = "data/final"
    local_dir = Rails.root.join("db", "imports").to_s 

    puts "Fetching files from GitHub repo: #{repo_url}, folder: #{folder_path}"

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, ".keep")
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    # Create a temporary directory
    Dir.mktmpdir do |temp_dir|
      system("git clone --no-checkout #{repo_url} #{temp_dir}")

      Dir.chdir(temp_dir) do
        # Enable sparse-checkout
        unless File.exist?(".git/info/sparse-checkout")
          system("git sparse-checkout init --cone")
          system("git sparse-checkout set #{folder_path}")
          system("git checkout")
        end

        # Sync only new/updated files from `data/final/` to `db/imports/`
        system("rsync -av --update --exclude='*.md' #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Import complete! Only new/updated files copied to #{local_dir}."
  end

  desc "Import Borough Data from .geojson file"
  task boroughs: :environment do
    filepath = Rails.root.join('db', 'imports', 'boroughs.geojson')
    ImportHelpers.import_geojson_with_fips(filepath, Borough, ["Polygon", "MultiPolygon"])
  end

  desc "Import Regional Corporation Data from .geojson file"
  task regional_corporations: :environment do
    filepath = Rails.root.join('db', 'imports', 'regional_corporations.geojson')
    ImportHelpers.import_geojson_with_fips(filepath, RegionalCorporation, ["Polygon", "MultiPolygon"])
  end

  desc "Import Community Data from .geojson file"
  task communities: :environment do
    filepath = Rails.root.join('db', 'imports', 'communities.geojson')
    ImportHelpers.import_geojson_with_fips(filepath, Community, ["Point"])
  end

  desc "Import Population Data from .csv file"
  task populations: :environment do
    filepath = Rails.root.join('db', 'imports', 'populations.csv')
    ImportHelpers.import_csv_with_fips(filepath, Population)
  end

  desc "Import Transportation Data from .csv file"
  task transportation: :environment do
    filepath = Rails.root.join('db', 'imports', 'transportation.csv')
    ImportHelpers.import_csv_with_fips(filepath, Transportation)
  end
end
