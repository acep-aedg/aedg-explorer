class BulkFuelFacility < ApplicationRecord
  include BulkFuelFacilityAttributes
  validates :location, allowed_geometry_types: %w[Point], allow_nil: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :bulk_fuel_facilities, optional: false

  def as_geojson
    {
      type: 'Feature',
      geometry: RGeo::GeoJSON.encode(location),
      properties: {
        name: name,
        barge_delivery: barge_delivery,
        plane_delivery: plane_delivery,
        road_delivery: road_delivery
      }
    }
  end
end
