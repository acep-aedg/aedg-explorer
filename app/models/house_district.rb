class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  has_many :communities_legislative_districts, dependent: :destroy
  has_many :communities, through: :communities_legislative_districts
  
  def self.as_geojson(districts)
    {
      type: "FeatureCollection",
      features: districts.map do |district|
        {
          type: "Feature",
          geometry: RGeo::GeoJSON.encode(district.boundary),
          properties: {
            id: district.district,
            name: district.name,
            tooltip: "House: #{district.district} - #{district.name}"
          }
        }
      end
    }
  end
end
