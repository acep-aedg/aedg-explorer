require 'csv'
require 'rgeo/geo_json'
require_relative 'import_helpers'
require_relative 'versioning'

namespace :import do
  desc 'Import Data Files into the Database'
  task all: [:environment] do
    Rake::Task['import:pull_gh_data'].invoke
    puts 'Importing data files...'
    Rake::Task['import:boroughs'].invoke
    Rake::Task['import:regional_corporations'].invoke
    Rake::Task['import:grids'].invoke
    Rake::Task['import:reporting_entities'].invoke
    Rake::Task['import:electric_rates'].invoke
    Rake::Task['import:sales'].invoke
    Rake::Task['import:senate_districts'].invoke
    Rake::Task['import:house_districts'].invoke
    Rake::Task['import:school_districts'].invoke
    Rake::Task['import:communities'].invoke
    Rake::Task['import:income_poverty'].invoke
    Rake::Task['import:household_income'].invoke
    Rake::Task['import:service_areas'].invoke
    Rake::Task['import:service_area_geoms'].invoke
    Rake::Task['import:community_service_area_geoms'].invoke
    Rake::Task['import:plants'].invoke
    Rake::Task['import:capacities'].invoke
    Rake::Task['import:bulk_fuel_facilities'].invoke
    Rake::Task['import:yearly_generations'].invoke
    Rake::Task['import:monthly_generations'].invoke
    Rake::Task['import:community_grids'].invoke
    Rake::Task['import:populations'].invoke
    Rake::Task['import:transportation'].invoke
    Rake::Task['import:populations_ages_sexes'].invoke
    Rake::Task['import:employments'].invoke
    Rake::Task['import:fuel_prices'].invoke
    puts 'Import complete'

    # On success, record the new version
    if DataPondVersion.latest&.current_version == Import::Versioning::DATA_POND_TAG
      puts "DataPondVersion already up to date: #{Import::Versioning::DATA_POND_TAG}"
    else
      data_pond_tag = Import::Versioning::DATA_POND_TAG
      DataPondVersion.create!(current_version: data_pond_tag)
      puts "DataPondVersion recorded: #{data_pond_tag}"
    end
  end

  desc 'Import data files from a specific GitHub tag'
  task pull_gh_data: :environment do
    repo_url = ENV.fetch('GH_DATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')
    tag = Import::Versioning::DATA_POND_TAG
    folder_path = 'data/final'
    Rails.root.join('db/imports').to_s
    local_dir = Rails.root.join('db/imports').to_s

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, '.keep')
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    # Check if the tag exists before cloning
    tag_exists = system("git ls-remote --tags #{repo_url} refs/tags/#{tag} | grep #{tag}")
    raise "Error: Tag '#{tag}' not found in repository #{repo_url}." unless tag_exists

    Dir.mktmpdir do |temp_dir|
      system("git clone --no-checkout #{repo_url} #{temp_dir}")

      Dir.chdir(temp_dir) do
        system('git fetch --tags')

        # Checkout the specific tag
        system("git checkout tags/#{tag} -b temp-tag-branch")

        # Enable sparse-checkout
        system('git sparse-checkout init --cone')
        system("git sparse-checkout set #{folder_path}")

        # Sync only new/updated files
        system("rsync -av --update --exclude='*.md' #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Import complete! #{tag} files copied to #{local_dir}."
  end

  desc 'Import data files from a specific GitHub PR (TEMP for testing)'
  task test_pr_data: :environment do
    repo_url   = ENV.fetch('GH_DATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')
    pr_number  = 49 # <<< TEMP: hardcode the PR you want to test
    folder_path = 'data/final'
    local_dir   = Rails.root.join('db/imports').to_s

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, '.keep')
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    Dir.mktmpdir do |temp_dir|
      # Clone the repo without checking out a branch yet
      system("git clone --no-checkout #{repo_url} #{temp_dir}") or
        raise "Failed to clone #{repo_url}"

      Dir.chdir(temp_dir) do
        # Fetch the PR ref into a local branch pr-<number>
        # This grabs the PR's HEAD (contributor branch), not the auto-merge ref.
        system("git fetch origin pull/#{pr_number}/head:pr-#{pr_number}") or
          raise "Failed to fetch PR ##{pr_number} from origin"

        # Check out the PR branch
        system("git checkout pr-#{pr_number}") or
          raise "Failed to checkout PR branch pr-#{pr_number}"

        # Enable sparse-checkout
        system('git sparse-checkout init --cone') or
          raise 'Failed to init sparse-checkout'
        system("git sparse-checkout set #{folder_path}") or
          raise "Failed to set sparse-checkout path #{folder_path}"

        # Sync only new/updated files
        system("rsync -av --update --exclude='*.md' #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Import complete! PR ##{pr_number} files copied to #{local_dir}."
  end

  desc 'Import Borough Data from .geojson file'
  task boroughs: :environment do
    filepath = Rails.root.join('db/imports/boroughs/boroughs.geojson')
    ImportHelpers.import_geojson(filepath, Borough)
  end

  desc 'Import Regional Corporation Data from .geojson file'
  task regional_corporations: :environment do
    filepath = Rails.root.join('db/imports/regional_corporations/regional_corporations.geojson')
    ImportHelpers.import_geojson(filepath, RegionalCorporation)
  end

  desc 'Import Grid Data from .csv file'
  task grids: :environment do
    filepath = Rails.root.join('db/imports/grids/grids.csv')
    ImportHelpers.import_csv(filepath, Grid)
  end

  desc 'Import Reporting Entities Data from .csv file'
  task reporting_entities: :environment do
    filepath = Rails.root.join('db/imports/reporting_entities/reporting_entities.csv')
    ImportHelpers.import_csv(filepath, ReportingEntity)
  end

  desc 'Import Electric Rates Data from .csv file'
  task electric_rates: :environment do
    filepath = Rails.root.join('db/imports/electric_rates/electric_rates.csv')
    ImportHelpers.import_csv(filepath, ElectricRate)
  end

  desc 'Import Sales Data from .csv file'
  task sales: :environment do
    filepath = Rails.root.join('db/imports/sales/sales.csv')
    ImportHelpers.import_csv(filepath, Sale)
  end

  desc 'Import Community Data from .geojson file'
  task communities: :environment do
    filepath = Rails.root.join('db/imports/communities/communities.geojson')
    ImportHelpers.import_geojson(filepath, Community)
  end

  desc 'Import Service Area Data from .geojson file'
  task service_areas: :environment do
    filepath = Rails.root.join('db/imports/service_areas/service_areas.geojson')
    ImportHelpers.import_geojson(filepath, ServiceArea)
  end

  desc 'Import Service Area Geom Data from .geojson file'
  task service_area_geoms: :environment do
    filepath = Rails.root.join('db/imports/service_area_geoms/service_area_geoms.geojson')
    ImportHelpers.import_geojson(filepath, ServiceAreaGeom)
  end

  desc 'Import Community Service Area Geom Data from .csv file'
  task community_service_area_geoms: :environment do
    filepath = Rails.root.join('db/imports/communities_service_area_geoms/communities_service_area_geoms.csv')
    ImportHelpers.import_csv(filepath, CommunitiesServiceAreaGeom)
  end

  desc 'Import Plant  Data from .geojson file'
  task plants: :environment do
    filepath = Rails.root.join('db/imports/plants/plants.geojson')
    ImportHelpers.import_geojson(filepath, Plant)
  end

  desc 'Import Community Grid Data from .csv file'
  task community_grids: :environment do
    filepath = Rails.root.join('db/imports/communities_grids/communities_grids.csv')
    ImportHelpers.import_csv(filepath, CommunityGrid)
  end

  desc 'Import Population Data from .csv file'
  task populations: :environment do
    filepath = Rails.root.join('db/imports/populations/populations.csv')
    ImportHelpers.import_csv(filepath, Population)
  end

  desc 'Import Transportation Data from .csv file'
  task transportation: :environment do
    filepath = Rails.root.join('db/imports/transportation/transportation.csv')
    ImportHelpers.import_csv(filepath, Transportation)
  end

  desc 'Import Yearly Generation Data from .csv file'
  task yearly_generations: :environment do
    filepath = Rails.root.join('db/imports/yearly_generation/yearly_generation.csv')
    ImportHelpers.import_csv(filepath, YearlyGeneration)
  end

  desc 'Import Monthly Generation Data from .csv file'
  task monthly_generations: :environment do
    if MonthlyGeneration.count > 0
      raise <<~ERROR
        ❌ ERROR: MonthlyGeneration table was not empty before starting import!
        To clear it, run:

            rails delete:monthly_generations

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/monthly_generation/monthly_generation.csv')
    ImportHelpers.import_csv(filepath, MonthlyGeneration)
  end

  desc 'Import Population, Ages, Sexes Data from .csv file'
  task populations_ages_sexes: :environment do
    filepath = Rails.root.join('db/imports/populations_ages_sexes/populations_ages_sexes.csv')
    ImportHelpers.import_csv(filepath, PopulationAgeSex)
  end

  desc 'Import Employment Data from .csv file'
  task employments: :environment do
    if Employment.count > 0
      raise <<~ERROR
        ❌ ERROR: Employment table was not empty before starting import!
        To clear it, run:

            rails delete:employments

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/employment/employment.csv')
    ImportHelpers.import_csv(filepath, Employment)
  end

  desc 'Import Capacity Data from .csv file'
  task capacities: :environment do
    if Capacity.count > 0
      raise <<~ERROR
        ❌ ERROR: Capacity table was not empty before starting import!
        To clear it, run:

            rails delete:capacities

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/capacity/capacity.csv')
    ImportHelpers.import_csv(filepath, Capacity)
  end

  desc 'Import House Districts Data from .geojson file'
  task house_districts: :environment do
    if HouseDistrict.count > 0
      raise <<~ERROR
        ❌ ERROR: House District table was not empty before starting import!
        To clear it and all realted tables, run:

            rails delete:districts

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/house_districts/house_districts.geojson')
    ImportHelpers.import_geojson(filepath, HouseDistrict)
  end

  desc 'Import Senate Districts Data from .geojson file'
  task senate_districts: :environment do
    if SenateDistrict.count > 0
      raise <<~ERROR
        ❌ ERROR: Senate District table was not empty before starting import!
        To clear it and all realted tables, run:

            rails delete:districts

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/senate_districts/senate_districts.geojson')
    ImportHelpers.import_geojson(filepath, SenateDistrict)
  end

  desc 'Import School Districts Data from .geojson file'
  task school_districts: :environment do
    if SchoolDistrict.count > 0
      raise <<~ERROR
        ❌ ERROR: School District table was not empty before starting import!
        To clear it and all related tables, run:

            rails delete:districts

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/school_districts/school_districts.geojson')
    ImportHelpers.import_geojson(filepath, SchoolDistrict)
  end

  desc 'Import Fuel Prices Data from .csv file'
  task fuel_prices: :environment do
    if FuelPrice.count > 0
      raise <<~ERROR
        ❌ ERROR: Fuel Price table was not empty before starting import!
        To clear it and all realted tables, run:

            rails delete:fuel_prices

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/fuel_prices/fuel_prices.csv')
    ImportHelpers.import_csv(filepath, FuelPrice)
  end

  desc 'Import Bulk Fuel Facilities Data from .geojson file'
  task bulk_fuel_facilities: :environment do
    if BulkFuelFacility.count > 0
      raise <<~ERROR
        ❌ ERROR: Bulk Fuel Facility table was not empty before starting import!
        To clear it and all related tables, run:
            rails delete:bulk_fuel_facilities
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/bulk_fuel/bulk_fuel.geojson')
    ImportHelpers.import_geojson(filepath, BulkFuelFacility)
  end

  desc 'Import Income Poverty Data from .csv file'
  task income_poverty: :environment do
    if IncomePoverty.count > 0
      raise <<~ERROR
        ❌ ERROR: Income Poverty table was not empty before starting import!
        To clear it and all related tables, run:
            rails delete:income_poverty
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/income_poverty/income_poverty.csv')
    ImportHelpers.import_csv(filepath, IncomePoverty)
  end

  desc 'Import Household Income Data from .csv file'
  task household_income: :environment do
    if HouseholdIncome.count > 0
      raise <<~ERROR
        ❌ ERROR: Household Income table was not empty before starting import!
        To clear it and all related tables, run:
            rails delete:household_income
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join('db/imports/household_income/household_income.csv')
    ImportHelpers.import_csv(filepath, HouseholdIncome)
  end
end
