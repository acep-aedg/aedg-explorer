require_relative 'delete_helpers'

namespace :delete do
  desc 'Clear monthly generations data'
  task monthly_generations: :environment do
    DeleteHelpers.delete_records(MonthlyGeneration)
  end

  desc 'Clear employments data'
  task employments: :environment do
    DeleteHelpers.delete_records(Employment)
  end

  desc 'Clear capacities data'
  task capacities: :environment do
    DeleteHelpers.delete_records(Capacity)
  end

  desc 'Clear house districts data'
  task house_districts: :environment do
    DeleteHelpers.delete_records(HouseDistrict)
  end

  desc 'Clear all district-related tables'
  task districts: :environment do
    DeleteHelpers.delete_records(CommunitiesLegislativeDistrict)
    DeleteHelpers.delete_records(CommunitiesSenateDistrict)
    DeleteHelpers.delete_records(CommunitiesHouseDistrict)
    DeleteHelpers.delete_records(HouseDistrict)
    DeleteHelpers.delete_records(SenateDistrict)
    DeleteHelpers.delete_records(SchoolDistrict)
  end

  desc 'Clear all fuel prices data'
  task fuel_prices: :environment do
    DeleteHelpers.delete_records(FuelPrice)
  end

  desc 'Clear all electric rate data'
  task electric_rates: :environment do
    DeleteHelpers.delete_records(ElectricRate)
  end

  desc 'Clear all bulk fuel facilities data'
  task bulk_fuel_facilities: :environment do
    DeleteHelpers.delete_records(BulkFuelFacility)
  end

  desc 'Clear all income poverty data'
  task income_poverty: :environment do
    DeleteHelpers.delete_records(IncomePoverty)
  end

  desc 'Clear all household income data'
  task household_income: :environment do
    DeleteHelpers.delete_records(HouseholdIncome)
  end
end
