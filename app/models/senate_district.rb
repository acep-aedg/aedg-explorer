class SenateDistrict < ApplicationRecord
  include SenateDistrictAttributes
  has_many :communities_legislative_districts, dependent: :destroy
  has_many :communities, through: :communities_legislative_districts

  validates :boundary, presence: true, allowed_geometry_types: ["Polygon", "MultiPolygon"]

  def self.as_geojson(districts)
    {
      type: "FeatureCollection",
      features: districts.map do |district|
        {
          type: "Feature",
          geometry: RGeo::GeoJSON.encode(district.boundary),
          properties: {
            id: district.district,
            tooltip: "Senate: #{district.district}"
          }
        }
      end
    }
  end
end
