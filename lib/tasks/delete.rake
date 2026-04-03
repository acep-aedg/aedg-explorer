require_relative "delete_helpers"

# These tasks should be named according the Model's table name
namespace :delete do
  desc "Clear monthly_generations data"
  task monthly_generations: :environment do
    DeleteHelpers.delete_records(MonthlyGeneration)
  end

  desc "Clear yearly_generations data"
  task yearly_generations: :environment do
    DeleteHelpers.delete_records(YearlyGeneration)
  end

  desc "Clear employments data"
  task employments: :environment do
    DeleteHelpers.delete_records(Employment)
  end

  desc "Clear capacities data"
  task capacities: :environment do
    DeleteHelpers.delete_records(Capacity)
  end

  desc "Clear fuel_prices data"
  task fuel_prices: :environment do
    DeleteHelpers.delete_records(FuelPrice)
  end

  desc "Clear yearly_electric_rates data"
  task yearly_electric_rates: :environment do
    DeleteHelpers.delete_records(YearlyElectricRate)
  end

  desc "Clear monthly_electric_rates data"
  task monthly_electric_rates: :environment do
    DeleteHelpers.delete_records(MonthlyElectricRate)
  end

  desc "Clear monthly_sales Data"
  task monthly_sales: :environment do
    DeleteHelpers.delete_records(MonthlySale)
  end

  desc "Clear yearly_sales Data"
  task yearly_sales: :environment do
    DeleteHelpers.delete_records(YearlySale)
  end

  desc "Clear bulk_fuel_facilities data"
  task bulk_fuel_facilities: :environment do
    DeleteHelpers.delete_records(BulkFuelFacility)
  end

  desc "Clear income_poverties data"
  task income_poverties: :environment do
    DeleteHelpers.delete_records(IncomePoverty)
  end

  desc "Clear household_incomes data"
  task household_incomes: :environment do
    DeleteHelpers.delete_records(HouseholdIncome)
  end

  desc "Clear heating_degree_days data"
  task heating_degree_days: :environment do
    DeleteHelpers.delete_records(HeatingDegreeDay)
  end

  desc "Clear generators data"
  task generators: :environment do
    DeleteHelpers.delete_records(Generator)
  end

  desc "Clear populations data"
  task populations: :environment do
    DeleteHelpers.delete_records(Population)
  end

  desc "Clear transportations data"
  task transportations: :environment do
    DeleteHelpers.delete_records(Transportation)
  end

  desc "Clear populations_ages_sexes data"
  task population_age_sexes: :environment do
    DeleteHelpers.delete_records(PopulationAgeSex)
  end

  desc "Clear community_grids data"
  task community_grids: :environment do
    DeleteHelpers.delete_records(CommunityGrid)
  end

  desc "Clear communities_reporting_entities data"
  task communities_reporting_entities: :environment do
    DeleteHelpers.delete_records(CommunitiesReportingEntity)
  end
end
