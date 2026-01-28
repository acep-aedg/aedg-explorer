# app/views/communities/charts/poverty_rate.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  chart_data = []

  if @community.income_poverties.show_poverty_rate_chart?
    data = @community.income_poverties.map do |r|
      year    = r[:end_year].to_i
      poverty = r[:e_pop_below_poverty]&.to_f
      total   = r[:e_pop_of_poverty_det]&.to_f

      # Logic: Must have both numbers, and they must be > 0
      value =
        (((poverty / total) * 100).round(2) if poverty&.positive? && total && total.positive?)

      [year, value]
    end.sort_by(&:first)

    chart_data << { name: "Poverty Rate", data: data }
  end

  json.array! chart_data
end
