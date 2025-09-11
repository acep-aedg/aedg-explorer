class CommunitiesServiceAreaGeom < ApplicationRecord
  include CommunitiesServiceAreaGeomAttributes
  validates :community_fips_code, presence: true
  validates :service_area_aedg_geom_id, presence: true

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :communities_service_area_geoms
  belongs_to :service_area_geom, foreign_key: :service_area_aedg_geom_id, primary_key: :aedg_geom_id, inverse_of: :communities_service_area_geoms
end
