class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  has_many :communities_legislative_districts, dependent: :destroy
  has_many :communities, through: :communities_legislative_districts

  validates :boundary, presence: true, allowed_geometry_types: ["Polygon", "MultiPolygon"]

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: district,
        tooltip: "House District: #{district} - #{name}"
      }
    }
  end
end
