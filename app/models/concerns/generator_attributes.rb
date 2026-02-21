module GeneratorAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      Generator.new.tap do |infra|
        infra.assign_aedg_attributes(properties)
        infra.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        plant_generator_id: params[:plant_generator_id],
        status: params[:status],
        data_source_year: params[:data_source_year],
        engine_make: params[:engine_make],
        engine_model: params[:engine_model],
        technology: params[:technology],
        prime_mover: params[:prime_mover],
        name_of_water_source: params[:name_of_water_source],
        ownership: params[:ownership],
        nameplate_capacity_mw: params[:nameplate_capacity_mw],
        storage_capacity_mw: params[:storage_capacity_mw],
        nameplate_power_factor: params[:nameplate_power_factor],
        summer_capacity_mw: params[:summer_capacity_mw],
        winter_capacity_mw: params[:winter_capacity_mw],
        minimum_load_mw: params[:minimum_load_mw],
        uprate_or_derate_completed: params[:uprate_or_derate_completed],
        month_uprate_or_derate_completed: params[:month_uprate_or_derate_completed],
        year_uprate_or_derate_completed: params[:year_uprate_or_derate_completed],
        syncronized_to_transmission_grid: params[:syncronized_to_transmission_grid],
        operating_month: params[:operating_month],
        operating_year: params[:operating_year],
        planned_or_actual_retirement_month: params[:planned_or_actual_retirement_month],
        planned_or_actual_retirement_year: params[:planned_or_actual_retirement_year],
        associated_with_combined_heat_and_power_system: params[:associated_with_combined_heat_and_power_system],
        sector_name: params[:sector_name],
        sector: params[:sector],
        energy_source_1: params[:energy_source_1],
        energy_source_2: params[:energy_source_2],
        startup_source_1: params[:startup_source_1],
        startup_source_2: params[:startup_source_2],
        turbines_or_hydrokinetic_bouys: params[:turbines_or_hydrokinetic_bouys],
        startup_time_minutes: params[:startup_time_minutes],
        multiple_fuels: params[:multiple_fuels],
        cofire_fuels: params[:cofire_fuels],
        switch_between_oil_and_natural_gas: params[:switch_between_oil_and_natural_gas],
        notes: params[:notes],
        source: params[:source]
      )
    end
  end
end
