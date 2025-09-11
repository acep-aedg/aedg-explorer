class CreatePlants < ActiveRecord::Migration[8.0]
  def change
    create_table :plants do |t|
      t.timestamps
      t.integer :aea_plant_id
      t.integer :eia_plant_id
      t.string :name
      t.integer :aea_operator_id
      t.integer :eia_operator_id
      t.integer :grid_id
      t.string :service_area_geom_aedg_id
      t.boolean :eia_reporting
      t.boolean :pce_reporting
      t.boolean :combined_heat_power
      t.decimal :primary_voltage
      t.decimal :primary_voltage2
      t.string :phases
      t.string :status
      t.string :notes
      t.geometry :location
    end

    add_foreign_key :plants, :grids
    add_foreign_key :plants, :service_area_geoms, column: :service_area_geom_aedg_id, primary_key: :aedg_id
  end
end
