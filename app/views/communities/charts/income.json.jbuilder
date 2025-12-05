@per_capita_income_data = @community.income_poverties
  .map { |r| [r[:end_year].to_i, r[:e_per_capita_income].to_i] }
  .sort_by(&:first).to_a
  
# --- 2. Median Household Income Data Processing (Source: household_incomes) ---

@median_hh_income_data = @community.household_incomes
  .map { |r| [r[:end_year].to_i, r[:e_household_median_income].to_i] }
  .sort_by(&:first).to_a

# --- 3. Combined JSON Output (Array of Series) ---

json.array! [
  {
    name: 'Per Capita Income',
    data: @per_capita_income_data
  },
  {
    name: 'Median Household Income',
    data: @median_hh_income_data
  }
]