class CreateIncomePoverties < ActiveRecord::Migration[8.0]
  def change
    create_table :income_poverties do |t|
      t.string :community_fips_code
      t.integer :e_per_capita_income
      t.integer :m_per_capita_income
      t.integer :e_pop_below_poverty
      t.integer :m_pop_below_poverty
      t.integer :e_pop_of_poverty_det
      t.integer :m_pop_of_poverty_det
      t.integer :start_year
      t.integer :end_year
      t.timestamps
    end
  end
end
