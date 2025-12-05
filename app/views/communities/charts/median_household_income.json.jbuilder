# app/views/communities/charts/median_income.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  @median_hh_income_data = @community.household_incomes
                                     .map { |r| [r[:end_year].to_i, r[:e_household_median_income].to_i] }
                                     .sort_by(&:first).to_a

  json.array! [
    {
      name: 'Median Household Income',
      data: @median_hh_income_data
    }
  ]
end
