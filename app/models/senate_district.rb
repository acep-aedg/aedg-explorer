class SenateDistrict < ApplicationRecord
  include SenateDistrictAttributes

  include Facetable

  has_many :communities_senate_districts, dependent: :destroy
  has_many :communities, through: :communities_senate_districts

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
