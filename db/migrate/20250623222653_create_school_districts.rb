class CreateSchoolDistricts < ActiveRecord::Migration[8.0]
  def change
    create_table :school_districts do |t|
      t.integer :district, null: false # Unique identifier for the school district
      t.string :name
      t.string :district_type
      t.boolean :is_active
      t.string :notes
      t.geometry :boundary

      t.timestamps
    end

    add_index :school_districts, :district, unique: true
    add_index :school_districts, :name, unique: true
    add_index :school_districts, :boundary, using: :gist
  end
end
