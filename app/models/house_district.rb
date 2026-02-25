class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  include Facetable

  has_many :communities_house_districts, dependent: :destroy
  has_many :communities, through: :communities_house_districts

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  def to_s
    "#{district} - #{name}"
  end

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: id,                 # Database bigint ID
        district: district,     # The number/code (e.g., "36")
        name: name,             # The name (e.g., "Copper River Basin")
        category: "House District Area", # Static label for the popup header
        as_of: as_of_date       # Metadata to show later
      }
    }
  end
end
