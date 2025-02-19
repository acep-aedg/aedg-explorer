class CreateBoroughs < ActiveRecord::Migration[7.1]
  def change
    create_table :boroughs do |t|
      t.string :fips_code, null: false
      t.string :name, null: false
      t.boolean :is_census_area
      t.geometry :boundary, geographic: true

      t.timestamps
    end
    add_index :boroughs, :fips_code, unique: true
    add_index :boroughs, :boundary, using: :gist
  end
end
