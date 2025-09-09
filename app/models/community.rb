class Community < ApplicationRecord
  include CommunityAttributes
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :borough, foreign_key: :borough_fips_code, primary_key: :fips_code
  belongs_to :regional_corporation, foreign_key: :regional_corporation_fips_code, primary_key: :fips_code, optional: true
  has_many :employments, foreign_key: :community_fips_code, primary_key: :fips_code
  has_one :transportation, foreign_key: :community_fips_code, primary_key: :fips_code
  has_one :population, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :population_age_sexes, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :community_grids, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :grids, through: :community_grids
  has_many :capacities, through: :grids
  has_many :monthly_generations, through: :grids
  has_many :yearly_generations, through: :grids
  has_many :fuel_prices, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  belongs_to :reporting_entity, optional: true
  has_many :electric_rates, through: :reporting_entity
  has_many :communities_senate_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :senate_districts, through: :communities_senate_districts
  has_many :communities_house_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :house_districts, through: :communities_house_districts
  has_many :communities_school_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :school_districts, through: :communities_school_districts

  # Handle the case where the name is not unique
  def slug_candidates
    [:name, %i[name fips_code]]
  end

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :borough_fips_code, presence: true
  validates :location, presence: true, allowed_geometry_types: ['Point']

  default_scope { order(name: :asc) }
  scope :with_location, -> { where.not(location: nil) }

  def grid
    community_grids.find_by(termination_year: 9999)&.grid
  end

  def available_price_types
    types = []
    types << 'Survey' if any_survey_prices?
    types << 'Regional' if any_regional_prices?
    types
  end

  def any_survey_prices?
    @any_survey_prices ||= fuel_prices.any? { |fp| fp.price_type.to_s.downcase == 'survey' && fp.price.present? }
  end

  def any_regional_prices?
    @any_regional_prices ||= fuel_prices.any? { |fp| fp.price_type.to_s.downcase == 'regional' && fp.price.present? }
  end

  # --- Electricity Section ---
  def show_utilities?
    @show_utilities ||= show_main_utility? || show_grid_utilities?
  end

  def show_grid_utilities?
    @show_grid_utilities ||= grid&.reporting_entities&.exists?
  end

  def show_main_utility?
    @show_main_utility ||= reporting_entity.present?
  end

  def show_rates?
    @show_rates ||= electric_rates&.any? do |rate|
      rate.residential_rate || rate.commercial_rate || rate.industrial_rate
    end
  end

  def show_production?
    @show_production ||= show_monthly_generation? || show_yearly_generation?
  end

  def show_yearly_generation?
    @show_yearly_generation ||= grid&.yearly_generations&.exists?
  end

  def show_monthly_generation?
    @show_monthly_generation ||= grid&.monthly_generations&.exists?
  end

  def show_capacity?
    @show_capacity ||= grid&.capacities&.exists?
  end

  def show_sales_revenue_customers?
    @show_sales_revenue_customers ||= reporting_entity&.sales&.exists?
  end

  def show_electricity_section?
    @show_electricity_section ||= show_utilities? || show_rates? || show_production? || show_capacity? || show_sales_revenue_customers?
  end

  # --- Prices Section ---
  def show_fuel_prices?
    @show_fuel_prices ||= fuel_prices.exists?
  end

  def show_prices_section?
    @show_prices_section ||= show_fuel_prices?
  end

  # --- Background Section ---
  def show_geography?
    @show_geography ||= community_grids.any?
  end

  def show_transportation?
    @show_transportation ||= transportation.present?
  end

  def show_legislative_districts?
    @show_legislative_districts ||= show_senate_districts? || show_house_districts?
  end

  def show_senate_districts?
    @show_senate_districts ||= senate_districts.any?
  end

  def show_house_districts?
    @show_house_districts ||= house_districts.any?
  end

  def show_population?
    @show_population ||= population_age_sexes.exists?
  end

  def show_school_districts?
    @show_school_districts ||= school_districts.exists?
  end

  def show_operators?
    ## Check for the presence of grid as some communities spatially have operators but no a grid
    @show_operators ||= operators.present? && grid.present?
  end

  def show_background_section?
    @show_background_section ||= show_transportation? || show_legislative_districts? || show_population?
  end

  def show_climate?
    @show_climate ||= show_heating_degree_days?
  end

  def show_heating_degree_days?
    @show_heating_degree_days ||= heating_degree_days.present? && heating_degree_days.positive?
  end
end
