class SenateDistrict < ApplicationRecord
  include SenateDistrictAttributes
  include Displayable
  include Searchable
  include Facetable
  extend FriendlyId

  ## Override the settings from Searchable
  scope :starts_with, ->(query) { where("district ilike ?", "#{query}%") }
  pg_search_scope :search,
                  against: :district,
                  using: {
                    tsearch: {
                      prefix: true
                    },
                    trigram: {
                      word_similarity: true
                    }
                  }

  friendly_id :district, use: :slugged

  has_many :communities_senate_districts, foreign_key: :senate_district_district, primary_key: :district, dependent: :destroy, inverse_of: :senate_district
  has_many :communities, through: :communities_senate_districts
  has_many :reporting_entities, through: :communities
  has_many :service_area_geoms,
           lambda { |district|
             unscope(:where).where(
               "ST_Intersects(
                   service_area_geoms.boundary,
                   (SELECT boundary FROM senate_districts WHERE id = ?)
                 )",
               district.id
             )
           },
           dependent: :nullify,
           inverse_of: false
  has_many :plants, through: :service_area_geoms
  has_many :service_areas, -> { distinct }, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  scope :facet_search, ->(term) { where("district ILIKE ?", "%#{term}%") }
  scope :facet_alpha,  ->(char) { where("district ILIKE ?", "#{char}%") }

  def to_s
    district
  end

  def long_name
    "#{self.class.model_name.human.titleize} #{self}"
  end

  def boundary_map_layer
    "layer-senate"
  end

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: id,
        category: "Senate District Area",
        title: "District #{district}",
        district_code: district
      }
    }
  end
end
