class Community < ApplicationRecord
  include CommunityAttributes
  include Displayable
  # include SearchableByNameAndTags
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
  has_many :communities_reporting_entities, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :reporting_entities, through: :communities_reporting_entities
  has_many :yearly_sales, through: :reporting_entities
  has_many :monthly_sales, through: :reporting_entities
  has_many :electric_rates, through: :reporting_entities
  has_many :communities_senate_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :senate_districts, through: :communities_senate_districts
  has_many :communities_house_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :house_districts, through: :communities_house_districts
  has_many :communities_school_districts, foreign_key: :community_fips_code, primary_key: :fips_code
  has_many :school_districts, through: :communities_school_districts
  has_one :communities_service_area_geom, foreign_key: :community_fips_code, primary_key: :fips_code
  has_one :service_area_geom, through: :communities_service_area_geom
  has_one :service_area, through: :service_area_geom
  has_many :plants, through: :service_area_geom
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants
  has_many :bulk_fuel_facilities, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :income_poverties, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :household_incomes, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :heating_degree_days, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community

  has_many :peer_communities, ->(community) { where.not(id: community.id).distinct }, through: :service_area_geom, source: :communities

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :borough_fips_code, presence: true
  validates :location, presence: true, allowed_geometry_types: ["Point"]

  scope :with_location, ->        { where.not(location: nil) }
  scope :in_boroughs,   ->(codes) { joins(:borough).where(boroughs: { fips_code: codes }) }
  scope :in_corps,      ->(codes) { where(regional_corporation_fips_code: codes) }
  scope :in_grids,      ->(ids)   { joins(:grids).where(grids: { id: ids }) }
  scope :in_senate,     ->(ids)   { joins(:senate_districts).where(senate_districts: { id: ids }) }
  scope :in_house,      ->(ids)   { joins(:house_districts).where(house_districts: { id: ids }) }
  # uses the pg_search_scope defined in SearchableByNameAndTags concern
  scope :starts_with,   ->(ch)    { where("name ilike ?", "#{ch}%") }
  scope :pce_eligible, -> { where(pce_eligible: true) }

  include PgSearch::Model

  pg_search_scope :search_full_text,
                  against: [:name],
                  using: {
                    # dmetaphone: {},
                    tsearch: {
                      prefix: true,
                      tsvector_column: "tsvector_data"
                    },
                    trigram: {
                      word_similarity: true
                    }
                  }

  pg_search_scope :search_related,
                  against: [:name],
                  associated_against: {
                    house_districts: :name,
                    grids: :name
                  },
                  using: {
                    # dmetaphone: {},
                    tsearch: {
                      prefix: true
                    }
                    # trigram: {}
                  }

  # Handle the case where the name is not unique
  def slug_candidates
    [:name, %i[name fips_code]]
  end

  def self.advanced_search_facets
    [
      { id: "offcanvasGrids",    param: :grid_ids,                        model: Grid,                lookup: :id,        prefix: "grid",   label_method: :name,
        title: "Electric Grid" },
      { id: "offcanvasBoroughs", param: :borough_fips_codes,              model: Borough,             lookup: :fips_code, prefix: "boro",   label_method: :name,
        title: "Borough / Census Area" },
      { id: "offcanvasCorps",    param: :regional_corporation_fips_codes, model: RegionalCorporation, lookup: :fips_code, prefix: "corp",   label_method: :name,
        title: "Native Regional Corp" },
      { id: "offcanvasSenate",   param: :senate_district_ids,             model: SenateDistrict,      lookup: :id,        prefix: "senate", label_method: lambda { |i|
        i.district.to_s
      }, title: "Senate District" },
      { id: "offcanvasHouse", param: :house_district_ids, model: HouseDistrict, lookup: :id, prefix: "house", label_method: :name, title: "House District" }
    ]
  end

  def self.search_facets_globally(query)
    return [] if query.blank?

    results = []
    advanced_search_facets.each do |facet|
      model = facet[:model]
      search_col = model.column_names.include?("name") ? "name" : "district"
      matches = model.where("#{model.table_name}.#{search_col} ILIKE ?", "%#{query}%").limit(5)

      matches.each do |match|
        results << {
          label: facet[:label_method].is_a?(Proc) ? facet[:label_method].call(match) : match.send(facet[:label_method]),
          category: facet[:title],
          param_key: facet[:param],
          value: match.send(facet[:lookup])
        }
      end
    end
    results
  end

  def grid
    community_grids.find_by(termination_year: 9999)&.grid
  end

  def to_s
    name
  end

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(location),
      properties: {
        id: fips_code,
        category: "Community Location",
        title: name,
        content: content,
        path: community_path_link,
        (borough&.census_area? ? :census_area : :borough) => borough&.name,
        regional_corporation: regional_corporation&.name,
        village_corporation: village_corporation,
        economic_region: economic_region,
        population: population&.total_population
      }.compact
    }
  end

  def available_price_types
    types = []
    types << "Survey" if any_survey_prices?
    types << "Regional" if any_regional_prices?
    types
  end

  def any_survey_prices?
    @any_survey_prices ||= fuel_prices.any? { |fp| fp.price_type.to_s.downcase == "survey" && fp.price.present? }
  end

  def any_regional_prices?
    @any_regional_prices ||= fuel_prices.any? { |fp| fp.price_type.to_s.downcase == "regional" && fp.price.present? }
  end

  # Specific to Community
  def local_service_area?
    service_area&.service_area_geoms&.many?
  end
end
