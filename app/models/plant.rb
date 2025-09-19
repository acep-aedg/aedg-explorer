class Plant < ApplicationRecord
  include PlantAttributes

  validates :name, presence: true
  validates :location, allowed_geometry_types: %w[Point], allow_nil: true
  belongs_to :grid, optional: true
  belongs_to :service_area_geom, primary_key: :aedg_id, foreign_key: :service_area_geom_aedg_id, optional: true, inverse_of: :plants
  has_one :service_area, through: :service_area_geom
  has_many :communities, through: :service_area_geom

  def as_geojson
    {
      type: 'Feature',
      geometry: RGeo::GeoJSON.encode(location),
      properties: {
        id: id,
        tooltip: name
      }
    }
  end
end
