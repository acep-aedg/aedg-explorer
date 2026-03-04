module BulkFuelFacilityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["location"] = geom
      properties.symbolize_keys!

      new.tap do |facility|
        facility.assign_aedg_attributes(properties)
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
      {}.merge(delivery_bullets)
        .merge(capacity_rows)
        .merge(infrastructure_rows)
        .compact
    end

    private

    def delivery_bullets
      {
        "_road" => road_delivery ? "Road Delivery" : nil,
        "_barge" => barge_delivery ? "Barge Delivery" : nil,
        "_plane" => plane_delivery ? "Plane Delivery" : nil
      }
    end

    def capacity_rows
      {
        "Diesel" => format_fuel(diesel_capacity),
        "Gasoline" => format_fuel(gasoline_capacity),
        "Jet Fuel" => format_fuel(jet_fuel_capacity),
        "Total Capacity" => format_fuel(total_capacity)
      }
    end

    def infrastructure_rows
      {
        "Tanks" => number_of_tanks.to_i.positive? ? number_of_tanks : nil,
        "Supplier" => fuel_supplier.presence,
        "USCG Inspected" => inspected_by_uscg ? "Yes" : "No",
        "Mooring Dist." => distance_to_barge_mooring.present? ? "#{distance_to_barge_mooring} miles" : nil
      }
    end

    def format_fuel(amount)
      return unless amount.to_i.positive?

      "#{ActiveSupport::NumberHelper.number_to_delimited(amount)} gal"
    end
  end
end
