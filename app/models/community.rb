class Community < ApplicationRecord
  include CommunityAttributes
  include SearchableByNameAndTags
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
  has_many :fuel_prices, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  belongs_to :reporting_entity, optional: true, touch: true
  has_many :sales, through: :reporting_entity
  has_many :electric_rates, through: :reporting_entity
  has_many :communities_senate_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :senate_districts, through: :communities_senate_districts
  has_many :communities_house_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :house_districts, through: :communities_house_districts
  has_many :communities_school_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :school_districts, through: :communities_school_districts
  has_many :communities_service_area_geoms, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :service_area_geoms, through: :communities_service_area_geoms
  has_many :service_areas, through: :service_area_geoms
  has_many :plants, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants
  has_many :bulk_fuel_facilities, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :income_poverties, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :household_incomes, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :borough_fips_code, presence: true
  validates :location, presence: true, allowed_geometry_types: ['Point']

  default_scope { order(name: :asc) }
  scope :with_location, -> { where.not(location: nil) }
  scope :in_boroughs, ->(codes) { codes.present? ? where(borough_fips_code: codes) : all }
  scope :in_borough, ->(code) { code.present? ? where(borough_fips_code: code) : all }
  scope :in_corps, ->(codes) { codes.present? ? where(regional_corporation_fips_code: codes) : all }
  scope :in_grids, ->(ids) { ids.present? ? where(id: joins(:grids).where(grids: { id: ids }).select(:id)) : all }
  scope :in_senate, lambda { |ids|
    ids.present? ? where(id: joins(:senate_districts).where(senate_districts: { id: ids }).group('communities.id').having('COUNT(DISTINCT senate_districts.id) = ?', ids.size).select(:id)) : all
  }
  scope :in_house, lambda { |ids|
    ids.present? ? where(id: joins(:house_districts).where(house_districts: { id: ids }).group('communities.id').having('COUNT(DISTINCT house_districts.id) = ?', ids.size).select(:id)) : all
  }
  scope :starts_with, ->(q) { where('name ILIKE ?', "#{q}%") if q.present? }
  scope :search_full_text, ->(q) { q.present? ? where('name ILIKE ?', "%#{q}%") : all }

  # Handle the case where the name is not unique
  def slug_candidates
    [:name, %i[name fips_code]]
  end

  def grid
    community_grids.find_by(termination_year: 9999)&.grid
  end

  def as_geojson
    {
      type: 'Feature',
      geometry: RGeo::GeoJSON.encode(location),
      properties: {
        title: name,
        (borough&.census_area? ? :census_area : :borough) => borough&.name,
        regional_corporation: regional_corporation&.name,
        village_corporation: village_corporation,
        economic_region: economic_region,
        population: population&.total_population
      }.compact
    }
  end

  def peers_by_service_area_geoms
    @peers_by_service_area_geoms ||= Community.joins(:communities_service_area_geoms)
                                              .where(communities_service_area_geoms: { service_area_geom_aedg_id: service_area_geom_ids })
                                              .where.not(id: id).distinct.to_a
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
    @show_utilities ||= show_service_areas? || show_utility_map_layers? || show_peers_by_service_area_geoms?
  end

  def show_service_areas?
    @show_service_areas ||= service_areas.any?
  end

  def show_full_service_area?
    return @show_full_service_area if instance_variable_defined?(:@show_full_service_area)

    ids = Array(service_area_geom_ids).compact.uniq
    @show_full_service_area =
      if ids.empty?
        false
      else
        ServiceArea
          .joins(:service_area_geoms)
          .where(service_area_geoms: { aedg_id: ids })
          .where.not(service_areas: { boundary: nil })
          .where.not(service_area_geoms: { boundary: nil })
          .where(Arel.sql('NOT ST_Equals(service_areas.boundary, service_area_geoms.boundary)'))
          .exists?
      end
  end

  def show_service_area_geoms?
    @show_service_area_geoms ||= service_area_geoms.exists?
  end

  def show_plants?
    @show_plants ||= plants.exists?
  end

  def show_utility_map_layers?
    @show_utility_map_layers ||= show_full_service_area? || show_service_area_geoms? || show_plants?
  end

  def show_peers_by_service_area_geoms?
    @show_peers_by_service_area_geoms ||= peers_by_service_area_geoms.any?
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
    @show_yearly_generation ||= plants&.any? && plants.flat_map(&:yearly_generations)&.any?
  end

  def show_monthly_generation?
    @show_monthly_generation ||= plants&.any? && plants.flat_map(&:monthly_generations)&.any?
  end

  def show_capacity?
    @show_capacity ||= plants&.any? && plants.flat_map(&:capacities)&.any?
  end

  def show_sales_revenue_customers?
    @show_sales_revenue_customers ||= reporting_entity&.sales&.exists?
  end

  def show_bulk_fuel_facilities?
    @show_bulk_fuel_facilities ||= bulk_fuel_facilities.exists?
  end

  def show_bulk_fuel_capacity_chart?
    capacity_fields = %i[gasoline_capacity diesel_capacity jet_fuel_capacity other_fuel_capacity]
    @show_bulk_fuel_capacity_chart ||= bulk_fuel_facilities.any? { |b| capacity_fields.any? { |field| b[field].present? } }
  end

  def show_electricity_section?
    @show_electricity_section ||= show_utilities? || show_rates? || show_production? || show_capacity? || show_sales_revenue_customers? || show_bulk_fuel_facilities?
  end

  # --- Prices Section ---
  def show_fuel_prices?
    @show_fuel_prices ||= fuel_prices.exists?
  end

  def show_prices_section?
    @show_prices_section ||= show_fuel_prices?
  end

  # --- Income Section ---
  def show_household_income?
    @show_household_income ||= household_incomes.any?
  end

  def show_income_poverty?
    @show_income_poverty ||= income_poverties.any?
  end

  def show_income_section?
    @show_income_section ||= show_household_income? || show_income_poverty?
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
