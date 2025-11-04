class BulkFuelFacility < ApplicationRecord
  include BulkFuelFacilityAttributes
  validates :location, allowed_geometry_types: %w[Point], allow_nil: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :bulk_fuel_facilities, optional: false

  def self.capacity_by_fuel_type(scope = all)
    totals = {
      'Gasoline' => scope.sum(:gasoline_capacity),
      'Diesel' => scope.sum(:diesel_capacity),
      'AvGas' => scope.sum(:av_gas_capacity),
      'Jet Fuel' => scope.sum(:jet_fuel_capacity),
      'Other' => scope.sum(:other_fuel_capacity)
    }

    totals.reject { |_, v| v.to_i.zero? }.to_a
  end

  def as_geojson
    {
      type: 'Feature',
      geometry: RGeo::GeoJSON.encode(location),
      properties: {
        name: name,
        inspected_by_uscg: inspected_by_uscg,
        fuel_supplier: fuel_supplier,
        barge_delivery: barge_delivery,
        plane_delivery: plane_delivery,
        road_delivery: road_delivery
      }
    }
  end
end
