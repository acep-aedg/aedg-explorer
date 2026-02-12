require "csv"
require "rgeo/geo_json"
require_relative "import_helpers"
require_relative "versioning"

namespace :import do
  desc "Import Data Files into the Database (Defaults to DATA_POND_TAG, or pass PR=123 for testing)"
  task all: [:environment] do
    Rake::Task["import:download_data"].invoke

    puts "Importing data files..."
    Rake::Task["import:boroughs"].invoke
    Rake::Task["import:regional_corporations"].invoke
    Rake::Task["import:grids"].invoke
    Rake::Task["import:reporting_entities"].invoke
    Rake::Task["import:electric_rates"].invoke
    Rake::Task["import:sales"].invoke
    Rake::Task["import:senate_districts"].invoke
    Rake::Task["import:house_districts"].invoke
    Rake::Task["import:school_districts"].invoke
    Rake::Task["import:communities"].invoke
    Rake::Task["import:community_reporting_entities"].invoke
    Rake::Task["import:income_poverty"].invoke
    Rake::Task["import:household_income"].invoke
    Rake::Task["import:service_areas"].invoke
    Rake::Task["import:service_area_geoms"].invoke
    Rake::Task["import:community_service_area_geoms"].invoke
    Rake::Task["import:plants"].invoke
    Rake::Task["import:capacities"].invoke
    Rake::Task["import:bulk_fuel_facilities"].invoke
    Rake::Task["import:yearly_generations"].invoke
    Rake::Task["import:monthly_generations"].invoke
    Rake::Task["import:community_grids"].invoke
    Rake::Task["import:populations"].invoke
    Rake::Task["import:transportation"].invoke
    Rake::Task["import:populations_ages_sexes"].invoke
    Rake::Task["import:employments"].invoke
    Rake::Task["import:fuel_prices"].invoke
    Rake::Task["import:heating_degree_days"].invoke
    puts "Import complete"

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
    if HeatingDegreeDay.any?
      raise <<~ERROR
        ❌ ERROR: Heating Degree Days table was not empty before starting import!
        To clear it, run:
            rails delete:heating_degree_days
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/heating_degree_days/heating_degree_days.csv")
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
    ImportHelpers.import_geojson(filepath, Community)
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
    ImportHelpers.import_csv(filepath, YearlyGeneration)
  end

  desc "Import Monthly Generation Data from .csv file"
  task monthly_generations: :environment do
    if MonthlyGeneration.any?
      raise <<~ERROR
        ❌ ERROR: MonthlyGeneration table was not empty before starting import!
        To clear it, run:

            rails delete:monthly_generations

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/monthly_generation/monthly_generation.csv")
    ImportHelpers.import_csv(filepath, MonthlyGeneration)
  end

  desc "Import Population, Ages, Sexes Data from .csv file"
  task populations_ages_sexes: :environment do
    filepath = Rails.root.join("db/imports/populations_ages_sexes/populations_ages_sexes.csv")
    ImportHelpers.import_csv(filepath, PopulationAgeSex)
  end

  desc "Import Employment Data from .csv file"
  task employments: :environment do
    if Employment.any?
      raise <<~ERROR
        ❌ ERROR: Employment table was not empty before starting import!
        To clear it, run:

            rails delete:employments

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/employment/employment.csv")
    ImportHelpers.import_csv(filepath, Employment)
  end

  desc "Import Capacity Data from .csv file"
  task capacities: :environment do
    if Capacity.any?
      raise <<~ERROR
        ❌ ERROR: Capacity table was not empty before starting import!
        To clear it, run:

            rails delete:capacities

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/capacity/capacity.csv")
    ImportHelpers.import_csv(filepath, Capacity)
  end

  desc "Import House Districts Data from .geojson file"
  task house_districts: :environment do
    if HouseDistrict.any?
      raise <<~ERROR
        ❌ ERROR: House District table was not empty before starting import!
        To clear it and all realted tables, run:

            rails delete:districts

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/house_districts/house_districts.geojson")
    ImportHelpers.import_geojson(filepath, HouseDistrict)
  end

  desc "Import Senate Districts Data from .geojson file"
  task senate_districts: :environment do
    if SenateDistrict.any?
      raise <<~ERROR
        ❌ ERROR: Senate District table was not empty before starting import!
        To clear it and all realted tables, run:

            rails delete:districts

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/senate_districts/senate_districts.geojson")
    ImportHelpers.import_geojson(filepath, SenateDistrict)
  end

  desc "Import School Districts Data from .geojson file"
  task school_districts: :environment do
    if SchoolDistrict.any?
      raise <<~ERROR
        ❌ ERROR: School District table was not empty before starting import!
        To clear it and all related tables, run:

            rails delete:districts

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/school_districts/school_districts.geojson")
    ImportHelpers.import_geojson(filepath, SchoolDistrict)
  end

  desc "Import Fuel Prices Data from .csv file"
  task fuel_prices: :environment do
    if FuelPrice.any?
      raise <<~ERROR
        ❌ ERROR: Fuel Price table was not empty before starting import!
        To clear it, run:

            rails delete:fuel_prices

        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/fuel_prices/fuel_prices.csv")
    ImportHelpers.import_csv(filepath, FuelPrice)
  end

  desc "Import Bulk Fuel Facilities Data from .geojson file"
  task bulk_fuel_facilities: :environment do
    if BulkFuelFacility.any?
      raise <<~ERROR
        ❌ ERROR: Bulk Fuel Facility table was not empty before starting import!
        To clear it, run:
            rails delete:bulk_fuel_facilities
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/bulk_fuel/bulk_fuel.geojson")
    ImportHelpers.import_geojson(filepath, BulkFuelFacility)
  end

  desc "Import Income Poverty Data from .csv file"
  task income_poverty: :environment do
    if IncomePoverty.any?
      raise <<~ERROR
        ❌ ERROR: Income Poverty table was not empty before starting import!
        To clear it, run:
            rails delete:income_poverty
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/income_poverty/income_poverty.csv")
    ImportHelpers.import_csv(filepath, IncomePoverty)
  end

  desc "Import Household Income Data from .csv file"
  task household_income: :environment do
    if HouseholdIncome.any?
      raise <<~ERROR
        ❌ ERROR: Household Income table was not empty before starting import!
        To clear it, run:
            rails delete:household_income
        Then, try running this import task again.
      ERROR
    end

    filepath = Rails.root.join("db/imports/household_income/household_income.csv")
    ImportHelpers.import_csv(filepath, HouseholdIncome)
  end
end
