class ServiceArea < ApplicationRecord
  include ServiceAreaAttributes
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]
  validates :cpcn_id, presence: true, uniqueness: true
  has_many :service_area_geoms, dependent: :destroy
end
