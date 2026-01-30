json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  chart_data = []

  if @community.income_poverties.show_per_capita_income_chart?
    data = @community.income_poverties.map do |r|
      [r[:end_year].to_i, r[:e_per_capita_income]&.to_i]
    end.sort_by(&:first)

    chart_data << { name: "Per Capita Income", data: data }
  end

  if @community.household_incomes.show_median_income_chart?
    data = @community.household_incomes.map do |r|
      [r[:end_year].to_i, r[:e_household_median_income]&.to_i]
    end.sort_by(&:first)

    chart_data << { name: "Median Household Income", data: data }
  end

  json.array! chart_data
end
