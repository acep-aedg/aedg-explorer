require "csv"
require "rgeo/geo_json"
require_relative "import_helpers"
require_relative "versioning"

namespace :import do
  desc "Import Data Files into the Database (Defaults to DATA_POND_TAG, or pass PR=123 for testing)"
  task all: %i[environment download_data] do
    start_time = Time.current
    puts "Starting full parallel import at #{start_time.strftime('%H:%M:%S')}..."
    Rake::Task["import:layer_one"].invoke
    Rake::Task["import:layer_two"].invoke
    Rake::Task["import:layer_three"].invoke
    Rake::Task["import:layer_four"].invoke
    Rake::Task["import:layer_five"].invoke
    Rake::Task["import:layer_six"].invoke
    Rake::Task["import:handle_version"].invoke

    duration_seconds = (Time.current - start_time).to_i
    minutes, seconds = duration_seconds.divmod(60)

    puts "Total time elapsed: #{minutes}m #{seconds}s"
  end

  # Imports with no dependencies
  multitask layer_one: %i[boroughs regional_corporations grids service_areas]

  # Imports that depend on layer one
  multitask layer_two: %i[senate_districts house_districts school_districts]

  # Imports that depend on layer two
  multitask layer_three: %i[communities reporting_entities service_area_geoms]

  # Imports that depend on layer three
  multitask layer_four: %i[plants community_service_area_geoms]

  # Imports that depend on layer four & earlier
  multitask layer_five: %i[monthly_generations yearly_generations heating_degree_days fuel_prices community_reporting_entities]

  multitask layer_six: %i[income_poverty household_income electric_rates sales miscellaneous]

  task miscellaneous: :environment do
    Rake::Task["import:community_grids"].invoke
    Rake::Task["import:generators"].invoke
    Rake::Task["import:populations"].invoke
    Rake::Task["import:transportation"].invoke
    Rake::Task["import:populations_ages_sexes"].invoke
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
    ImportHelpers.download_data("data/final", Rails.root.join("db/imports").to_s)
  end

  desc "Import Heating Degree Days Data from .csv file"
  task heating_degree_days: :environment do
    filepath = Rails.root.join("db/imports/heating_degree_days/heating_degree_days.csv")
    ImportHelpers.ensure_empty!(HeatingDegreeDay, "heating_degree_days")
    ImportHelpers.import_csv(filepath, HeatingDegreeDay)
  end

  desc "Import Borough Data from .geojson file"
  task boroughs: :environment do
    filepath = Rails.root.join("db/imports/boroughs/boroughs.geojson")
    ImportHelpers.import_geojson(filepath, Borough)
  end

  desc "Import Regional Corporation Data from .geojson file"
  task regional_corporations: :environment do
    filepath = Rails.root.join("db/imports/regional_corporations/regional_corporations.geojson")
    ImportHelpers.import_geojson(filepath, RegionalCorporation)
  end

  desc "Import Grid Data from .csv file"
  task grids: :environment do
    filepath = Rails.root.join("db/imports/grids/grids.csv")
    ImportHelpers.import_csv(filepath, Grid)
  end

  desc "Import Reporting Entities Data from .csv file"
  task reporting_entities: :environment do
    filepath = Rails.root.join("db/imports/reporting_entities/reporting_entities.csv")
    ImportHelpers.import_csv(filepath, ReportingEntity)
  end

  desc "Import Electric Rates Data from .csv file"
  task electric_rates: :environment do
    filepath = Rails.root.join("db/imports/electric_rates/electric_rates.csv")
    ImportHelpers.import_csv(filepath, ElectricRate)
  end

  desc "Import Sales Data from .csv file"
  task sales: :environment do
    filepath = Rails.root.join("db/imports/sales/sales.csv")
    ImportHelpers.import_csv(filepath, Sale)
  end

  desc "Import Community Data from .geojson file"
  task communities: :environment do
    filepath = Rails.root.join("db/imports/communities/communities.geojson")
    ImportHelpers.import_communities(filepath, Community)
  end

  desc "Import Service Area Data from .geojson file"
  task service_areas: :environment do
    filepath = Rails.root.join("db/imports/service_areas/service_areas.geojson")
    ImportHelpers.import_geojson(filepath, ServiceArea)
  end

  desc "Import Service Area Geom Data from .geojson file"
  task service_area_geoms: :environment do
    filepath = Rails.root.join("db/imports/service_area_geoms/service_area_geoms.geojson")
    ImportHelpers.import_geojson(filepath, ServiceAreaGeom)
  end

  desc "Import Community Service Area Geom Data from .csv file"
  task community_service_area_geoms: :environment do
    filepath = Rails.root.join("db/imports/communities_service_area_geoms/communities_service_area_geoms.csv")
    ImportHelpers.import_csv(filepath, CommunitiesServiceAreaGeom)
  end

  desc "Import Community Reporting Entity Data from .csv file"
  task community_reporting_entities: :environment do
    filepath = Rails.root.join("db/imports/communities_reporting_entities/communities_reporting_entities.csv")
    ImportHelpers.import_csv(filepath, CommunitiesReportingEntity)
  end

  desc "Import Plant  Data from .geojson file"
  task plants: :environment do
    filepath = Rails.root.join("db/imports/plants/plants.geojson")
    ImportHelpers.import_geojson(filepath, Plant)
  end

  desc "Import Community Grid Data from .csv file"
  task community_grids: :environment do
    filepath = Rails.root.join("db/imports/communities_grids/communities_grids.csv")
    ImportHelpers.import_csv(filepath, CommunityGrid)
  end

  desc "Import Population Data from .csv file"
  task populations: :environment do
    filepath = Rails.root.join("db/imports/populations/populations.csv")
    ImportHelpers.import_csv(filepath, Population)
  end

  desc "Import Transportation Data from .csv file"
  task transportation: :environment do
    filepath = Rails.root.join("db/imports/transportation/transportation.csv")
    ImportHelpers.import_csv(filepath, Transportation)
  end

  desc "Import Yearly Generation Data from .csv file"
  task yearly_generations: :environment do
    filepath = Rails.root.join("db/imports/yearly_generation/yearly_generation.csv")
    ImportHelpers.ensure_empty!(YearlyGeneration, "yearly_generations")
    ImportHelpers.import_csv(filepath, YearlyGeneration)
  end

  desc "Import Monthly Generation Data from .csv file"
  task monthly_generations: :environment do
    filepath = Rails.root.join("db/imports/monthly_generation/monthly_generation.csv")
    ImportHelpers.ensure_empty!(MonthlyGeneration, "monthly_generations")
    ImportHelpers.import_csv(filepath, MonthlyGeneration)
  end

  desc "Import Population, Ages, Sexes Data from .csv file"
  task populations_ages_sexes: :environment do
    filepath = Rails.root.join("db/imports/populations_ages_sexes/populations_ages_sexes.csv")
    ImportHelpers.import_csv(filepath, PopulationAgeSex)
  end

  desc "Import Employment Data from .csv file"
  task employments: :environment do
    filepath = Rails.root.join("db/imports/employment/employment.csv")
    ImportHelpers.ensure_empty!(Employment, "employments")
    ImportHelpers.import_csv(filepath, Employment)
  end

  desc "Import Capacity Data from .csv file"
  task capacities: :environment do
    filepath = Rails.root.join("db/imports/capacity/capacity.csv")
    ImportHelpers.ensure_empty!(Capacity, "capacities")
    ImportHelpers.import_csv(filepath, Capacity)
  end

  desc "Import House Districts Data from .geojson file"
  task house_districts: :environment do
    filepath = Rails.root.join("db/imports/house_districts/house_districts.geojson")
    ImportHelpers.ensure_empty!(HouseDistrict, "districts")
    ImportHelpers.import_geojson(filepath, HouseDistrict)
  end

  desc "Import Senate Districts Data from .geojson file"
  task senate_districts: :environment do
    filepath = Rails.root.join("db/imports/senate_districts/senate_districts.geojson")
    ImportHelpers.ensure_empty!(SenateDistrict, "districts")
    ImportHelpers.import_geojson(filepath, SenateDistrict)
  end

  desc "Import School Districts Data from .geojson file"
  task school_districts: :environment do
    filepath = Rails.root.join("db/imports/school_districts/school_districts.geojson")
    ImportHelpers.ensure_empty!(SchoolDistrict, "districts")
    ImportHelpers.import_geojson(filepath, SchoolDistrict)
  end

  desc "Import Fuel Prices Data from .csv file"
  task fuel_prices: :environment do
    filepath = Rails.root.join("db/imports/fuel_prices/fuel_prices.csv")
    ImportHelpers.ensure_empty!(FuelPrice, "fuel_prices")
    ImportHelpers.import_csv(filepath, FuelPrice)
  end

  desc "Import Bulk Fuel Facilities Data from .geojson file"
  task bulk_fuel_facilities: :environment do
    filepath = Rails.root.join("db/imports/bulk_fuel/bulk_fuel.geojson")
    ImportHelpers.ensure_empty!(BulkFuelFacility, "bulk_fuel_facilities")
    ImportHelpers.import_geojson(filepath, BulkFuelFacility)
  end

  desc "Import Income Poverty Data from .csv file"
  task income_poverty: :environment do
    filepath = Rails.root.join("db/imports/income_poverty/income_poverty.csv")
    ImportHelpers.ensure_empty!(IncomePoverty, "income_poverty")
    ImportHelpers.import_csv(filepath, IncomePoverty)
  end

  desc "Import Household Income Data from .csv file"
  task household_income: :environment do
    filepath = Rails.root.join("db/imports/household_income/household_income.csv")
    ImportHelpers.ensure_empty!(HouseholdIncome, "household_income")
    ImportHelpers.import_csv(filepath, HouseholdIncome)
  end

  desc "Import Generator Data from .csv file"
  task generators: :environment do
    filepath = Rails.root.join("db/imports/generators/generators.csv")
    ImportHelpers.ensure_empty!(Generator, "generators")
    ImportHelpers.import_csv(filepath, Generator)
  end
end
