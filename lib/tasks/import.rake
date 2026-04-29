require "csv"
require "rgeo/geo_json"
require_relative "import_helpers"
require_relative "data_download"
require_relative "versioning"

# These individual import model tasks should be named according the Model's table name
namespace :import do
  desc "Import Data Files into the Database (Defaults to DATA_POND_TAG, or pass PR=123 for testing)"
  task all: %i[environment download_data] do
    msg = "Loading Data..."
    # set loading data feature on the UI when
    ImportHelpers.with_import_banner(msg) do
      puts "🚀 Starting full import..."
      Rake::Task["import:layer_one"].invoke
      Rake::Task["import:layer_two"].invoke
      Rake::Task["import:layer_three"].invoke
      Rake::Task["import:layer_four"].invoke
      Rake::Task["import:layer_five"].invoke
      Rake::Task["import:layer_six"].invoke
      Rake::Task["import:handle_version"].invoke
      puts "✅ Full import complete..."
    end
  end

  # Imports with no dependencies
  multitask layer_one: %i[boroughs regional_corporations grids service_areas]

  # Imports that depend on layer one
  multitask layer_two: %i[senate_districts house_districts school_districts]

  # Imports that depend on layer two
  multitask layer_three: %i[communities reporting_entities service_area_geoms]

  # Imports that depend on layer three
  multitask layer_four: %i[plants communities_service_area_geoms communities_reporting_entities]

  # Imports that depend on layer four & earlier
  multitask layer_five: %i[monthly_generations yearly_generations heating_degree_days monthly_electric_rates monthly_sales]

  multitask layer_six: %i[income_poverties household_incomes yearly_electric_rates yearly_sales miscellaneous]

  task miscellaneous: :environment do
    Rake::Task["import:fuel_prices"].invoke
    Rake::Task["import:community_grids"].invoke
    Rake::Task["import:generators"].invoke
    Rake::Task["import:populations"].invoke
    Rake::Task["import:transportations"].invoke
    Rake::Task["import:population_age_sexes"].invoke
    Rake::Task["import:capacities"].invoke
    Rake::Task["import:employments"].invoke
    Rake::Task["import:bulk_fuel_facilities"].invoke
  end

  task handle_version: :environment do
    if ENV["PR"].present?
      puts "Skipping version tag update because this is a PR test."
    elsif DataPondVersion.latest&.current_version == Import::Versioning::DATA_POND_TAG
      puts "DataPondVersion already up to date: #{Import::Versioning::DATA_POND_TAG}"
    else
      data_pond_tag = Import::Versioning::DATA_POND_TAG
      DataPondVersion.create!(current_version: data_pond_tag)
      puts "DataPondVersion recorded: #{data_pond_tag}"
    end
  end

  desc "Download data files (Defaults to DATA_POND_TAG, or pass PR=123 to test a PR)"
  task download_data: :environment do
    DataDownload.download("data/final", Rails.root.join("db/imports").to_s)
  end

  desc "Import Heating Degree Days Data from .csv file"
  task heating_degree_days: :environment do
    filepath = Rails.root.join("db/imports/heating_degree_days/heating_degree_days.csv")
    ImportHelpers.batch_import_csv(filepath, HeatingDegreeDay)
  end

  desc "Import Borough Data from .geojson file"
  task boroughs: :environment do
    filepath = Rails.root.join("db/imports/boroughs/boroughs.geojson")
    ImportHelpers.batch_import_geojson(filepath, Borough)
  end

  desc "Import Regional Corporation Data from .geojson file"
  task regional_corporations: :environment do
    filepath = Rails.root.join("db/imports/regional_corporations/regional_corporations.geojson")
    ImportHelpers.batch_import_geojson(filepath, RegionalCorporation)
  end

  desc "Import Grid Data from .csv file"
  task grids: :environment do
    filepath = Rails.root.join("db/imports/grids/grids.csv")
    ImportHelpers.batch_import_csv(filepath, Grid)
  end

  desc "Import Reporting Entities Data from .csv file"
  task reporting_entities: :environment do
    filepath = Rails.root.join("db/imports/reporting_entities/reporting_entities.csv")
    ImportHelpers.batch_import_csv(filepath, ReportingEntity)
  end

  desc "Import Monthly Electric Rates Data from .csv file"
  task monthly_electric_rates: :environment do
    filepath = Rails.root.join("db/imports/monthly_electric_rates/monthly_electric_rates.csv")
    ImportHelpers.batch_import_csv(filepath, MonthlyElectricRate)
  end

  desc "Import Yearly Electric Rates Data from .csv file"
  task yearly_electric_rates: :environment do
    filepath = Rails.root.join("db/imports/yearly_electric_rates/yearly_electric_rates.csv")
    ImportHelpers.batch_import_csv(filepath, YearlyElectricRate)
  end

  desc "Import Monthly Sales Data from .csv file"
  task monthly_sales: :environment do
    filepath = Rails.root.join("db/imports/monthly_sales/monthly_sales.csv")
    ImportHelpers.batch_import_csv(filepath, MonthlySale)
  end

  desc "Import Yearly Sales Data from .csv file"
  task yearly_sales: :environment do
    filepath = Rails.root.join("db/imports/yearly_sales/yearly_sales.csv")
    ImportHelpers.batch_import_csv(filepath, YearlySale)
  end

  desc "Import Community Data from .geojson file"
  task communities: :environment do
    filepath = Rails.root.join("db/imports/communities/communities.geojson")
    ImportHelpers.import_geojson(filepath, Community)
  end

  desc "Import Service Area Data from .geojson file"
  task service_areas: :environment do
    filepath = Rails.root.join("db/imports/service_areas/service_areas.geojson")
    ImportHelpers.batch_import_geojson(filepath, ServiceArea)
  end

  desc "Import Service Area Geom Data from .geojson file"
  task service_area_geoms: :environment do
    filepath = Rails.root.join("db/imports/service_area_geoms/service_area_geoms.geojson")
    ImportHelpers.batch_import_geojson(filepath, ServiceAreaGeom)
  end

  desc "Import Community Service Area Geom Data from .csv file"
  task communities_service_area_geoms: :environment do
    filepath = Rails.root.join("db/imports/communities_service_area_geoms/communities_service_area_geoms.csv")
    ImportHelpers.batch_import_csv(filepath, CommunitiesServiceAreaGeom)
  end

  desc "Import Community Reporting Entity Data from .csv file"
  task communities_reporting_entities: :environment do
    filepath = Rails.root.join("db/imports/communities_reporting_entities/communities_reporting_entities.csv")
    ImportHelpers.batch_import_csv(filepath, CommunitiesReportingEntity)
  end

  desc "Import Plant Data from .geojson file"
  task plants: :environment do
    filepath = Rails.root.join("db/imports/plants/plants.geojson")
    ImportHelpers.batch_import_geojson(filepath, Plant)
  end

  desc "Import Community Grid Data from .csv file"
  task community_grids: :environment do
    filepath = Rails.root.join("db/imports/communities_grids/communities_grids.csv")
    ImportHelpers.batch_import_csv(filepath, CommunityGrid)
  end

  desc "Import Population Data from .csv file"
  task populations: :environment do
    filepath = Rails.root.join("db/imports/populations/populations.csv")
    ImportHelpers.batch_import_csv(filepath, Population)
  end

  desc "Import Transportation Data from .csv file"
  task transportations: :environment do
    filepath = Rails.root.join("db/imports/transportation/transportation.csv")
    ImportHelpers.batch_import_csv(filepath, Transportation)
  end

  desc "Import Yearly Generation Data from .csv file"
  task yearly_generations: :environment do
    filepath = Rails.root.join("db/imports/yearly_generation/yearly_generation.csv")
    ImportHelpers.batch_import_csv(filepath, YearlyGeneration)
  end

  desc "Import Monthly Generation Data from .csv file"
  task monthly_generations: :environment do
    filepath = Rails.root.join("db/imports/monthly_generation/monthly_generation.csv")
    ImportHelpers.batch_import_csv(filepath, MonthlyGeneration)
  end

  desc "Import Population, Ages, Sexes Data from .csv file"
  task population_age_sexes: :environment do
    filepath = Rails.root.join("db/imports/populations_ages_sexes/populations_ages_sexes.csv")
    ImportHelpers.batch_import_csv(filepath, PopulationAgeSex)
  end

  desc "Import Employment Data from .csv file"
  task employments: :environment do
    filepath = Rails.root.join("db/imports/employment/employment.csv")
    ImportHelpers.batch_import_csv(filepath, Employment)
  end

  desc "Import Capacity Data from .csv file"
  task capacities: :environment do
    filepath = Rails.root.join("db/imports/capacity/capacity.csv")
    ImportHelpers.batch_import_csv(filepath, Capacity)
  end

  desc "Import House Districts Data from .geojson file"
  task house_districts: :environment do
    filepath = Rails.root.join("db/imports/house_districts/house_districts.geojson")
    ImportHelpers.batch_import_geojson(filepath, HouseDistrict)
  end

  desc "Import Senate Districts Data from .geojson file"
  task senate_districts: :environment do
    filepath = Rails.root.join("db/imports/senate_districts/senate_districts.geojson")
    ImportHelpers.batch_import_geojson(filepath, SenateDistrict)
  end

  desc "Import School Districts Data from .geojson file"
  task school_districts: :environment do
    filepath = Rails.root.join("db/imports/school_districts/school_districts.geojson")
    ImportHelpers.batch_import_geojson(filepath, SchoolDistrict)
  end

  desc "Import Fuel Prices Data from .csv file"
  task fuel_prices: :environment do
    filepath = Rails.root.join("db/imports/fuel_prices/fuel_prices.csv")
    ImportHelpers.batch_import_csv(filepath, FuelPrice)
  end

  desc "Import Bulk Fuel Facilities Data from .geojson file"
  task bulk_fuel_facilities: :environment do
    filepath = Rails.root.join("db/imports/bulk_fuel/bulk_fuel.geojson")
    ImportHelpers.batch_import_geojson(filepath, BulkFuelFacility)
  end

  desc "Import Income Poverty Data from .csv file"
  task income_poverties: :environment do
    filepath = Rails.root.join("db/imports/income_poverty/income_poverty.csv")
    ImportHelpers.batch_import_csv(filepath, IncomePoverty)
  end

  desc "Import Household Income Data from .csv file"
  task household_incomes: :environment do
    filepath = Rails.root.join("db/imports/household_income/household_income.csv")
    ImportHelpers.batch_import_csv(filepath, HouseholdIncome)
  end

  desc "Import Generator Data from .csv file"
  task generators: :environment do
    filepath = Rails.root.join("db/imports/generators/generators.csv")
    ImportHelpers.batch_import_csv(filepath, Generator)
  end
end
