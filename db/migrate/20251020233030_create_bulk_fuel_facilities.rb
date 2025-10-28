class CreateBulkFuelFacilities < ActiveRecord::Migration[8.0]
  def change
    create_table :bulk_fuel_facilities do |t|
      t.uuid :dcra_code
      t.integer :tank_farm_id
      t.string :uscg_id
      t.string :aea_id
      t.string :community_fips_code
      t.string :name
      t.integer :number_of_tanks
      t.integer :total_capacity
      t.integer :gasoline_capacity
      t.integer :diesel_capacity
      t.integer :av_gas_capacity
      t.integer :jet_fuel_capacity
      t.integer :other_fuel_capacity
      t.boolean :barge_delivery
      t.boolean :plane_delivery
      t.boolean :road_delivery
      t.boolean :inspected_by_uscg
      t.string :fuel_supplier
      t.string :recommendations_by_aea
      t.string :distance_to_barge_mooring
      t.integer :tank_farm_evaluation_id
      t.string :data_source
      t.string :report

      t.geometry :location
      t.timestamps
    end
    add_foreign_key :bulk_fuel_facilities, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
