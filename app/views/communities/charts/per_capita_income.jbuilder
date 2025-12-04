# app/views/communities/charts/per_capita_income.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  @per_capita_income_data = @community.income_poverties
                                      .map { |r| [r[:end_year].to_i, r[:e_per_capita_income].to_i] }
                                      .sort_by(&:first).to_a

  json.array! [
    {
      name: 'Per Capita Income',
      data: @per_capita_income_data
    }
  ]
end
