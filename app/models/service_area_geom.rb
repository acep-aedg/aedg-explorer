class ServiceAreaGeom < ApplicationRecord
  include ServiceAreaGeomAttributes

  validates :aedg_id, presence: true, uniqueness: true
  validates :boundary, presence: true, allowed_geometry_types: %w[MultiPolygon Polygon]

  belongs_to :service_area, primary_key: :cpcn_id, foreign_key: :service_area_cpcn_id, inverse_of: :service_area_geoms
  has_many :communities_service_area_geoms, foreign_key: :service_area_geom_aedg_id, primary_key: :aedg_id, inverse_of: :service_area_geom, dependent: :destroy
  has_many :communities, through: :communities_service_area_geoms
  has_many :plants, primary_key: :aedg_id, foreign_key: :service_area_geom_aedg_id, inverse_of: :service_area_geom, dependent: :nullify

  scope :with_full_service_area, -> { joins(:service_area).where("NOT ST_Equals(service_area_geoms.boundary, service_areas.boundary)")}

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: id,
        tooltip: service_area&.name
      }
    }
  end
end
