class CreateServiceAreaGeoms < ActiveRecord::Migration[8.0]
  def change
    create_table :service_area_geoms do |t|
      t.string :aedg_geom_id, null: false
      t.integer :service_area_cpcn_id, null: false
      t.geometry :boundary
      t.timestamps
    end

    add_foreign_key :service_area_geoms, :service_areas, column: :service_area_cpcn_id, primary_key: :cpcn_id

    add_index :service_area_geoms, :service_area_cpcn_id
    add_index :service_area_geoms, :aedg_geom_id, unique: true
  end
end
