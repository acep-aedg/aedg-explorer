json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  @per_capita_income_data = @community.income_poverties
                                      .map { |r| [r[:end_year].to_i, r[:e_per_capita_income].to_i] }
                                      .sort_by(&:first).to_a

  @median_hh_income_data = @community.household_incomes
                                     .map { |r| [r[:end_year].to_i, r[:e_household_median_income].to_i] }
                                     .sort_by(&:first).to_a

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
end
