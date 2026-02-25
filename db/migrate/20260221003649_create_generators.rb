class CreateGenerators < ActiveRecord::Migration[8.0]
  def change
    create_table :generators do |t|
      t.integer :aea_plant_id, null: false
      t.integer :eia_plant_id
      t.string :plant_generator_id
      t.string :status
      t.integer :data_source_year
      t.string :engine_make
      t.string :engine_model
      t.string :technology
      t.string :prime_mover
      t.string :name_of_water_source
      t.string :ownership
      t.decimal :nameplate_capacity_mw
      t.decimal :storage_capacity_mw
      t.decimal :nameplate_power_factor
      t.decimal :summer_capacity_mw
      t.decimal :winter_capacity_mw
      t.decimal :minimum_load_mw
      t.boolean :uprate_or_derate_completed
      t.integer :month_uprate_or_derate_completed
      t.integer :year_uprate_or_derate_completed
      t.boolean :syncronized_to_transmission_grid
      t.integer :operating_month
      t.integer :operating_year
      t.integer :planned_or_actual_retirement_month
      t.integer :planned_or_actual_retirement_year
      t.boolean :associated_with_combined_heat_and_power_system
      t.string :sector_name
      t.integer :sector
      t.string :energy_source_1
      t.string :energy_source_2
      t.string :startup_source_1
      t.string :startup_source_2
      t.integer :turbines_or_hydrokinetic_bouys
      t.integer :startup_time_minutes
      t.boolean :multiple_fuels
      t.boolean :cofire_fuels
      t.boolean :switch_between_oil_and_natural_gas
      t.text :notes
      t.string :source
      t.timestamps
    end
  
    add_foreign_key :generators, :plants, column: :aea_plant_id, primary_key: :aea_plant_id
  end
end
