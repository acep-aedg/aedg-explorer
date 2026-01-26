class ServiceArea < ApplicationRecord
  include ServiceAreaAttributes

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]
  validates :cpcn_id, presence: true, uniqueness: true

  has_many :service_area_geoms, primary_key: :cpcn_id, foreign_key: :service_area_cpcn_id, dependent: :destroy, inverse_of: :service_area
  has_many :communities, through: :service_area_geoms

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: cpcn_id,
        tooltip: name
      }
    }
  end
end
