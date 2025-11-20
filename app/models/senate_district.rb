class SenateDistrict < ApplicationRecord
  include SenateDistrictAttributes
  has_many :communities_senate_districts, dependent: :destroy
  has_many :communities, through: :communities_senate_districts

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  def to_s
    district
  end

  def as_geojson
    {
      type: 'Feature',
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: district,
        tooltip: "Senate District: #{district}"
      }
    }
  end
end
