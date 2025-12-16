json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  @per_capita_income_data = @community.income_poverties
                                      .map do |r|
    year  = r[:end_year].to_i
    value = r[:e_per_capita_income].nil? ? nil : r[:e_per_capita_income].to_i
    [year, value]
  end
                                     .sort_by(&:first)
                                     .to_a

  @median_hh_income_data = @community.household_incomes
                                     .map do |r|
    year  = r[:end_year].to_i
    value = r[:e_household_median_income].nil? ? nil : r[:e_household_median_income].to_i
    [year, value]
  end
                                    .sort_by(&:first)
                                    .to_a

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
