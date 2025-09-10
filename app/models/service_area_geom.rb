class ServiceAreaGeom < ApplicationRecord
  include ServiceAreaGeomAttributes
  belongs_to :service_area
  validates :service_area_polygon_index, presence: true, uniqueness: true
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]
end
