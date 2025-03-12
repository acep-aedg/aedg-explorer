class CreateHouseDistricts < ActiveRecord::Migration[7.1]
  def change
    create_table :house_districts do |t|
      t.integer :house_district
      t.string :name
      t.date :as_of_date
      t.geometry :boundary, geographic: true

      t.timestamps
    end

    add_index :house_districts, :boundary, using: :gist
  end
end
