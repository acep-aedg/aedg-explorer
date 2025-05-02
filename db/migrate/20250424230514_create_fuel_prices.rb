class CreateFuelPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :fuel_prices do |t|
      t.string :community_fips_code
      t.decimal :price
      t.string :fuel_type
      t.string :price_type
      t.string :source
      t.string :reporting_season
      t.integer :reporting_year

      t.timestamps
    end
    add_index :fuel_prices, :community_fips_code
    add_foreign_key :fuel_prices, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
