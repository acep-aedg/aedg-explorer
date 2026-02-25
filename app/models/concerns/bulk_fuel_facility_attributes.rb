module BulkFuelFacilityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      properties["location"] = geom
      properties.symbolize_keys!

      BulkFuelFacility.new.tap do |facility|
        facility.assign_aedg_attributes(properties)
        facility.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        dcra_code: params[:dcra_code],
        tank_farm_id: params[:tank_farm_id],
        uscg_id: params[:uscg_id],
        aea_id: params[:aea_id],
        tank_farm_evaluation_id: params[:tank_farm_evaluation_id],
        community_fips_code: params[:community_fips_code],
        name: params[:entity_name],
        number_of_tanks: params[:number_of_tanks],
        total_capacity: params[:total_capacity],
        gasoline_capacity: params[:gasoline_capacity],
        diesel_capacity: params[:diesel_capacity],
        av_gas_capacity: params[:av_gas_capacity],
        jet_fuel_capacity: params[:jet_fuel_capacity],
        other_fuel_capacity: params[:other_fuel_capacity],
        barge_delivery: params[:barge_delivery],
        plane_delivery: params[:plane_delivery],
        road_delivery: params[:road_delivery],
        inspected_by_uscg: params[:inspected_by_uscg],
        fuel_supplier: params[:fuel_supplier],
        recommendations_by_aea: params[:recommendations_by_aea],
        distance_to_barge_mooring: params[:distance_to_barge_mooring],
        data_source: params[:data_source],
        report: params[:report],
        location: params[:location]
      )
    end

    def content
      {
        "_road"  => road_delivery ? "Road Delivery" : nil,
        "_barge" => barge_delivery ? "Barge Delivery" : nil,
        "_plane" => plane_delivery ? "Plane Delivery" : nil,
        "Diesel Capacity"         => diesel_capacity.to_i > 0   ? format_gal(diesel_capacity) : nil,
        "Gasoline Capacity"       => gasoline_capacity.to_i > 0 ? format_gal(gasoline_capacity) : nil,
        "Jet Fuel Capacity"       => jet_fuel_capacity.to_i > 0 ? format_gal(jet_fuel_capacity) : nil,
        "Total Capacity" => total_capacity.to_i > 0    ? format_gal(total_capacity) : nil,
        "Tanks"          => number_of_tanks.to_i > 0   ? number_of_tanks : nil,
        "Supplier"       => fuel_supplier.presence,
        "USCG Inspected" => inspected_by_uscg ? "Yes" : "No",
        "Mooring Dist."  => distance_to_barge_mooring.present? ? "#{distance_to_barge_mooring} ft" : nil
      }.compact
    end

    private

    def format_gal(number)
      "#{ActiveSupport::NumberHelper.number_to_delimited(number)} gal"
    end
  end
end
