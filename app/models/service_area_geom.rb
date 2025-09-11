class ServiceAreaGeom < ApplicationRecord
  include ServiceAreaGeomAttributes
  validates :aedg_geom_id, presence: true, uniqueness: true
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon]
  validates :service_area_cpcn_id, presence: true

  belongs_to :service_area, primary_key: :cpcn_id, foreign_key: :service_area_cpcn_id, inverse_of: :service_area_geoms
end
