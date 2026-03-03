# app/models/concerns/monthly_generation_attributes.rb
module MonthlyGenerationAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!
      new.tap do |monthly_gen|
        monthly_gen.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        fuel_type_code: params[:fuel_type_code],
        fuel_type_name: params[:fuel_type_name],
        year: params[:year],
        month: params[:month],
        generation_mwh: params[:generation_mwh],
        pce_fuel_price: params[:pce_fuel_price],
        physical_unit_label: params[:physical_unit_label],
        quantity_consumed_in_physical_units_for_electric_generation: params[:quantity_consumed_in_physical_units_for_electric_generation],
        quantity_consumed_for_electricity_mmbtu: params[:quantity_consumed_for_electricity_mmbtu],
        source: params[:source]
      )
    end
  end
end
