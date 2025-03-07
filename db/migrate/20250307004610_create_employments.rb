class CreateEmployments < ActiveRecord::Migration[7.1]
  def change
    create_table :employments do |t|
      t.string :community_fips_code
      t.integer :residents_employed
      t.integer :unemployment_insurance_claimants
      t.integer :measurement_year

      t.timestamps
    end
  end
end
