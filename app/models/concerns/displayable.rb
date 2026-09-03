module Displayable
  extend ActiveSupport::Concern

  def communities?
    try(:communities)&.any?
  end

  def pce_eligible_communities?
    (communities? && try(:communities)&.pce_eligible&.any?) || false
  end

  def school_districts?
    try(:school_districts)&.any?
  end

  def transportation?
    try(:transportation)&.present?
  end

  def house_districts?
    try(:house_districts)&.any?
  end

  def senate_districts?
    try(:senate_districts)&.any?
  end

  def yearly_generations?
    return @yearly_generations if defined?(@yearly_generations)

    @yearly_generations = try(:yearly_generations)&.any? || false
  end

  def monthly_generations?
    return @monthly_generations if defined?(@monthly_generations)

    @monthly_generations = try(:monthly_generations)&.any? || false
  end

  def capacities?
    return @capacities if defined?(@capacities)

    @capacities = try(:capacities)&.any? || false
  end

  def plants?
    return @plants if defined?(@plants)

    @plants = try(:plants)&.any? || false
  end

  def service_area_collection
    return @service_area_collection if defined?(@service_area_collection)

    @service_area_collection ||= if respond_to?(:service_areas)
                                   service_areas.to_a
                                 else
                                   Array(respond_to?(:service_area) ? service_area : nil).compact
                                 end
  end

  def service_areas?
    service_area_collection.any?
  end

  def fuel_prices?
    try(:fuel_prices)&.any?
  end

  def bulk_fuel_facilities?
    try(:bulk_fuel_facilities)&.any?
  end

  def bulk_fuel_facility_capacities?
    try(:bulk_fuel_facilities)&.with_capacity&.exists?
  end

  def employment?
    try(:employments)&.any?
  end

  def population_age_sexes?
    try(:population_age_sexes)&.any?
  end

  def heating_degree_days?
    try(:heating_degree_days)&.any?
  end

  def income_poverties?
    try(:income_poverties)&.any?
  end

  def household_incomes?
    try(:household_incomes)&.exists?
  end

  def yearly_electric_rates?
    try(:yearly_electric_rates)&.with_rates&.exists?
  end

  def sex_distribution?
    try(:population_age_sexes)&.with_sex_estimates&.exists?
  end

  def age_distribution?
    try(:population_age_sexes)&.with_age_estimates&.exists?
  end

  def yearly_electricity_sales?
    try(:yearly_sales)&.with_sales&.exists?
  end

  def yearly_electricity_revenues?
    try(:yearly_sales)&.with_revenue&.exists?
  end

  def yearly_electricity_customers?
    try(:yearly_sales)&.with_customers&.exists?
  end

  def boundary?
    self.class.column_names.include?("boundary") && boundary.present?
  end

  def local_service_area?
    return false unless respond_to?(:service_area_geoms) && respond_to?(:service_areas)

    @local_service_area ||= begin
      local_ids = service_area_geoms.ids
      ServiceAreaGeom.where(service_area_cpcn_id: service_areas.select(:cpcn_id)).where.not(id: local_ids).exists?
    end
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
    yearly_electricity_sales? || yearly_electric_rates? || yearly_electricity_revenues? || yearly_electricity_customers?
  end
end
