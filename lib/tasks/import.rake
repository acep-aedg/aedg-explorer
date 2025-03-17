require 'csv'
require 'rgeo/geo_json'
require_relative 'import_helpers'

namespace :import do
  desc "Import Data Files into the Database"
  task all: [:environment, "db:reset"] do
    Rake::Task['import:pull_gh_data'].invoke

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
    Rake::Task['import:communities_legislative_districts'].invoke
    Rake::Task['import:employment'].invoke
    Rake::Task['import:capacity'].invoke
  end

  desc "Import data files from a specific GitHub tag"
  task pull_gh_data: :environment do
    repo_url = ENV.fetch('GH_DATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')
    tag = ENV.fetch('GH_DATA_REPO_TAG')
    folder_path = "data/final"
    local_dir = Rails.root.join("db", "imports").to_s

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, ".keep")
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    # Check if the tag exists before cloning
    tag_exists = system("git ls-remote --tags #{repo_url} refs/tags/#{tag} | grep #{tag}")
    raise "Error: Tag '#{tag}' not found in repository #{repo_url}." unless tag_exists

    Dir.mktmpdir do |temp_dir|
      system("git clone --no-checkout #{repo_url} #{temp_dir}")

      Dir.chdir(temp_dir) do
        system("git fetch --tags")

        # Checkout the specific tag
        system("git checkout tags/#{tag} -b temp-tag-branch")

        # Enable sparse-checkout
        system("git sparse-checkout init --cone")
        system("git sparse-checkout set #{folder_path}")

        # Sync only new/updated files
        system("rsync -av --update --exclude='*.md' #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Import complete! #{tag} files copied to #{local_dir}."
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

    if MonthlyGeneration.count > 0
      raise <<~ERROR
        ❌ ERROR: MonthlyGeneration table was not empty before starting import!
        To clear it, run:

            rails delete:monthly_generations

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db', 'imports', 'monthly_generation.csv')
    ImportHelpers.import_csv(filepath, MonthlyGeneration)
  end

  desc "Import Population, Ages, Sexes Data from .csv file"
  task populations_ages_sexes: :environment do
    filepath = Rails.root.join('db', 'imports', 'populations_ages_sexes.csv')
    ImportHelpers.import_csv(filepath, PopulationAgeSex)
  end

  desc "Import Community Legislative Districts Data from .csv file"
  task communities_legislative_districts: :environment do
    filepath = Rails.root.join('db', 'imports', 'communities_legislative_districts.csv')
    ImportHelpers.import_csv(filepath, CommunitiesLegislativeDistrict)
  end

  desc "Import Employment Data from .csv file"
  task employments: :environment do
    if Employment.count > 0
      raise <<~ERROR
        ❌ ERROR: Employment table was not empty before starting import!
        To clear it, run:

            rails delete:employments

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db', 'imports', 'employment.csv')
    ImportHelpers.import_csv(filepath, Employment)
  end

  desc "Import Capacity Data from .csv file"
  task capacitys: :environment do
    if Capacity.count > 0
      raise <<~ERROR
        ❌ ERROR: Capacity table was not empty before starting import!
        To clear it, run:

            rails delete:capacitys

        Then, try running this import task again.
      ERROR
    end
    filepath = Rails.root.join('db', 'imports', 'capacity.csv')
    ImportHelpers.import_csv(filepath, Capacity)
  end
end
