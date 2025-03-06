require 'csv'
require 'rgeo/geo_json'
require_relative 'import_helpers'

namespace :import do
  desc "Import Data Files into the Database"
  task all: [:environment, "db:reset"] do
    Rake::Task['import:pull_github_files'].invoke

    puts "Importing data files..."
    Rake::Task['import:boroughs'].invoke
    Rake::Task['import:regional_corporations'].invoke
    Rake::Task['import:grids'].invoke
    Rake::Task['import:communities'].invoke
    Rake::Task['import:populations'].invoke
    Rake::Task['import:transportation'].invoke
    Rake::Task['import:yearly_generations'].invoke
    Rake::Task['import:monthly_generations'].invoke
    Rake::Task['import:populations_ages_sexes'].invoke
  end

  desc "Import only the data files from a specific GitHub folder"
  task pull_github_files: :environment do
    repo_url = ENV['GH_DATA_REPO_URL']
    folder_path = "data/final"
    local_dir = Rails.root.join("db", "imports").to_s 

    puts "Pulling latest files from GitHub: #{repo_url}, folder: #{folder_path}"

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
    ImportHelpers.import_geojson(filepath, Borough)
  end

  desc "Import Regional Corporation Data from .geojson file"
  task regional_corporations: :environment do
    filepath = Rails.root.join('db', 'imports', 'regional_corporations.geojson')
    ImportHelpers.import_geojson(filepath, RegionalCorporation)
  end

  desc "Import Grid Data from .csv file"
  task grids: :environment do
    filepath = Rails.root.join('db', 'imports', 'grids.csv')
    ImportHelpers.import_csv(filepath, Grid)
  end

  desc "Import Community Data from .geojson file"
  task communities: :environment do
    filepath = Rails.root.join('db', 'imports', 'communities.geojson')
    ImportHelpers.import_geojson(filepath, Community)
  end

  desc "Import Population Data from .csv file"
  task populations: :environment do
    filepath = Rails.root.join('db', 'imports', 'populations.csv')
    ImportHelpers.import_csv(filepath, Population)
  end

  desc "Import Transportation Data from .csv file"
  task transportation: :environment do
    filepath = Rails.root.join('db', 'imports', 'transportation.csv')
    ImportHelpers.import_csv(filepath, Transportation)
  end

  desc "Import Yearly Generation Data from .csv file"
  task yearly_generations: :environment do
    filepath = Rails.root.join('db', 'imports', 'yearly_generation.csv')
    ImportHelpers.import_csv(filepath, YearlyGeneration)
  end

  desc "Import Monthly Generation Data from .csv file"
  task monthly_generations: :environment do
    filepath = Rails.root.join('db', 'imports', 'monthly_generation.csv')
    ImportHelpers.import_csv(filepath, MonthlyGeneration)
  end

  desc "Import Population, Ages, Sexes Data from .csv file"
  task populations_ages_sexes: :environment do
    filepath = Rails.root.join('db', 'imports', 'populations_ages_sexes.csv')
    ImportHelpers.import_csv(filepath, PopulationAgeSex)
  end
end
