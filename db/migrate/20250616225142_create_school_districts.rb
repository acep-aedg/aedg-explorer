class CreateSchoolDistricts < ActiveRecord::Migration[8.0]
  def change
    create_table :school_districts do |t|
      t.string :name
      t.string :district_type
      t.boolean :is_active
      t.string :notes
      t.geometry :boundary, geographic: true

      t.timestamps
    end

    add_index :school_districts, :boundary, using: :gist
  end
end
