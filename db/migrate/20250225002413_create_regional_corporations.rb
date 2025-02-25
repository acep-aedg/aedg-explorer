class CreateRegionalCorporations < ActiveRecord::Migration[7.1]
  def change
    create_table :regional_corporations do |t|
      t.string :fips_code, null: false
      t.string :name, null: false
      t.geometry :boundary, geographic: true

      t.timestamps
    end
    add_index :regional_corporations, :fips_code, unique: true
    add_index :regional_corporations, :boundary, using: :gist
    add_foreign_key :communities, :regional_corporations, column: :regional_corporation_fips_code, primary_key: :fips_code

  end
end
