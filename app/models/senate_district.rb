class SenateDistrict < ApplicationRecord
  include SenateDistrictAttributes
  include Displayable
  include Searchable
  include Facetable
  extend FriendlyId

  self.searchable_column = :district
  friendly_id :district, use: :slugged

  has_many :communities_senate_districts, foreign_key: :senate_district_district, primary_key: :district, dependent: :destroy, inverse_of: :senate_district
  has_many :communities, through: :communities_senate_districts
  has_many :reporting_entities, through: :communities
  has_many :plants, through: :communities
  has_many :service_area_geoms, through: :plants
  has_many :service_areas, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  scope :facet_search, ->(term) { where("district ILIKE ?", "%#{term}%") }
  scope :facet_alpha,  ->(char) { where("district ILIKE ?", "#{char}%") }

  def to_s
    district
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
