class BulkFuelFacility < ApplicationRecord
  include BulkFuelFacilityAttributes

  validates :location, allowed_geometry_types: %w[Point], allow_nil: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :bulk_fuel_facilities, optional: false, touch: true

  scope :with_capacity, -> { where(capacity_fields.values.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }

  def self.capacity_fields
    {
      "Gasoline" => :gasoline_capacity,
      "Diesel" => :diesel_capacity,
      "AvGas" => :av_gas_capacity,
      "Jet Fuel" => :jet_fuel_capacity,
      "Other" => :other_fuel_capacity
    }
  end

  def self.capacity_by_fuel_type
    capacity_fields.each_with_object({}) do |(label, column), totals|
      sum = self.sum(column)
      totals[label] = sum unless sum.to_i.zero?
    end
  end

  def as_geojson
    {
      type: "Feature",
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
