class CreateServiceAreaGeoms < ActiveRecord::Migration[8.0]
  def change
    create_table :service_area_geoms do |t|
      t.string :service_area_polygon_index, null: false
      t.references :service_area, null: false, foreign_key: true
      t.geometry :boundary
      t.timestamps
    end
  end
end
