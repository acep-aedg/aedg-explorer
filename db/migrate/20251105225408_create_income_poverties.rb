class CreateIncomePoverties < ActiveRecord::Migration[8.0]
  def change
    create_table :income_poverties do |t|
      t.string :community_fips_code
      t.string :e_median_household_income
      t.string :m_median_household_income
      t.string :e_per_capita_income
      t.string :m_per_capita_income
      t.string :e_pop_below_poverty
      t.string :m_pop_below_poverty
      t.string :e_pop_of_poverty_det
      t.string :m_pop_of_poverty_det
      t.string :start_year
      t.string :end_year
      t.timestamps
    end
  end
end
