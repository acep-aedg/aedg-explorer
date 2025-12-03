class CreateHeatingDegreeDays < ActiveRecord::Migration[8.0]
  def change
    create_table :heating_degree_days do |t|
      t.string :community_fips_code
      t.integer :year
      t.integer :month
      t.integer :heating_degree_days

      t.timestamps
    end
    add_foreign_key :heating_degree_days, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
