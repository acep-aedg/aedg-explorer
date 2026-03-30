# rubocop:disable Metrics/ModuleLength
module Displayable
  extend ActiveSupport::Concern

  def communities?
    communities&.any?
  end

  def pce_eligible_communities?
    communities? && communities.pce_eligible.any?
  end

  def school_districts?
    school_districts&.any?
  end

  def transportation?
    transportation&.present?
  end

  def house_districts?
    house_districts&.any?
  end

  def senate_districts?
    senate_districts&.any?
  end

  def yearly_generations?
    yearly_generations&.any?
  end

  def monthly_generations?
    monthly_generations&.any?
  end

  def capacities?
    capacities&.any?
  end

  def plants?
    plants&.any?
  end

  def service_area_collection
    if respond_to?(:service_areas)
      service_areas.to_a
    elsif respond_to?(:service_area)
      [service_area].compact
    else
      []
    end
  end

  def service_areas?
    service_area_collection.any?
  end

  def fuel_prices?
    fuel_prices&.any?
  end

  def bulk_fuel_facilities?
    bulk_fuel_facilities&.any?
  end

  def bulk_fuel_facility_capacities?
    bulk_fuel_facilities&.with_capacity&.exists?
  end

  def employment?
    employments&.any?
  end

  def population_age_sexes?
    population_age_sexes&.any?
  end

  def heating_degree_days?
    heating_degree_days&.any?
  end

  def income_poverties?
    income_poverties&.any?
  end

  def household_incomes?
    household_incomes&.exists?
  end

  def electric_rates?
    electric_rates&.with_rates&.exists?
  end

  def sex_distribution?
    population_age_sexes&.with_sex_estimates&.exists?
  end

  def age_distribution?
    population_age_sexes&.with_age_estimates&.exists?
  end

  def yearly_electricity_sales?
    yearly_sales&.with_sales&.exists?
  end

  def yearly_electricity_revenues?
    yearly_sales&.with_revenue&.exists?
  end

  def yearly_electricity_customers?
    yearly_sales&.with_customers&.exists?
  end

  # --- Grouped ---

  def generation?
    yearly_generations? || monthly_generations?
  end

  def utilities?
    service_areas? || plants?
  end

  def power_generation?
    generation? || capacities? || utilities?
  end

  def fuel?
    fuel_prices? || bulk_fuel_facilities?
  end

  def income?
    income_poverties? || household_incomes?
  end

  def demographics?
    population_age_sexes? || employment?
  end

  def legislative_districts?
    house_districts? || senate_districts?
  end

  def electricity_sales_rates?
    yearly_electricity_sales? || electric_rates? || yearly_electricity_revenues? || yearly_electricity_customers?
  end
end
# rubocop:enable Metrics/ModuleLength
