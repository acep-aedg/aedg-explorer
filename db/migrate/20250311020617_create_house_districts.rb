class CreateHouseDistricts < ActiveRecord::Migration[7.1]
  def change
    create_table :house_districts do |t|
      t.integer :house_district
      t.geography :geometry
      t.date :as_of_date

      t.timestamps
    end
  end
end
