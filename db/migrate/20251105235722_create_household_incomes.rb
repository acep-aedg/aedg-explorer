class CreateHouseholdIncomes < ActiveRecord::Migration[8.0]
  def change
    # rubocop:disable Naming/VariableNumber
    create_table :household_incomes do |t|
      t.string :community_fips_code
      t.integer :e_households_total
      t.integer :e_household_median_income
      t.integer :e_household_inc_under_10000
      t.integer :e_household_inc_10000_14999
      t.integer :e_household_inc_15000_24999
      t.integer :e_household_inc_25000_34999
      t.integer :e_household_inc_35000_49999
      t.integer :e_household_inc_50000_74999
      t.integer :e_household_inc_75000_99999
      t.integer :e_household_inc_100000_149999
      t.integer :e_household_inc_150000_199999
      t.integer :e_household_inc_200000_plus
      t.integer :start_year
      t.integer :end_year
      t.timestamps
    end
    # rubocop:enable Naming/VariableNumber
  end
end
