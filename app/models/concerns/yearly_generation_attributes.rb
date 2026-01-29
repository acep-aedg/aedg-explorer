# app/models/concerns/yearly_generation_attributes.rb
module YearlyGenerationAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      YearlyGeneration.new.tap do |yearly_generation|
        yearly_generation.assign_aedg_attributes(properties)
        yearly_generation.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        year: params[:year],
        fuel_type_code: params[:fuel_type_code],
        fuel_type_name: params[:fuel_type_name],
        generation_mwh: params[:generation_mwh],
        avg_pce_fuel_price: params[:avg_pce_fuel_price],
        physical_unit_label: params[:physical_unit_label],
        quantity_consumed_in_physical_units_for_electric_generation: params[:quantity_consumed_in_physical_units_for_electric_generation],
        quantity_consumed_for_electricity_mmbtu: params[:quantity_consumed_for_electricity_mmbtu],
        source: params[:source]
      )
    end
  end
end
