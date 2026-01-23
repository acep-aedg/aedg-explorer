module PlantAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      properties['location'] = geom
      properties.symbolize_keys!

      Plant.new.tap do |plant|
        plant.assign_aedg_attributes(properties)
        plant.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        name: params[:name],
        aea_operator_id: params[:aea_operator_id],
        eia_operator_id: params[:eia_operator_id],
        grid: Grid.from_aedg_id(params[:grid_id]).first,
        service_area_geom_aedg_id: params[:service_area_geom_id],
        pce_reporting_id: params[:pce_reporting_id],
        combined_heat_power: params[:combined_heat_power],
        grid_primary_voltage_kv: params[:grid_primary_voltage_kv],
        grid_primary_voltage_2_kv: params[:grid_primary_voltage_2_kv],
        phases: params[:phases],
        notes: params[:notes],
        location: params[:location]
      )
    end
  end
end
