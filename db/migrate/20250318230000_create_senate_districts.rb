class CreateSenateDistricts < ActiveRecord::Migration[7.1]
  def change
    create_table :senate_districts do |t|
      t.string :district, null: false
      t.date :as_of_date
      t.geometry :boundary, geographic: true

      t.timestamps
    end

    add_index :senate_districts, :district, unique: true
    add_index :senate_districts, :boundary, using: :gist
  end
end
