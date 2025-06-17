class SchoolDistrict < ApplicationRecord
  include SchoolDistrictAttributes
  include ImportFinders

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  def as_geojson
    {
      type: 'Feature',
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: aedg_import&.aedg_id,
        tooltip: "School District: #{name}"
      }
    }
  end
end
