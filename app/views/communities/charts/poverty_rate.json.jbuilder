# app/views/communities/charts/poverty_rate.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  @poverty_rate_percentage_data = @community.income_poverties.map do |r|
    year    = r[:end_year].to_i
    poverty = r[:e_pop_below_poverty]&.to_f
    total   = r[:e_pop_of_poverty_det]&.to_f

    value =
      if poverty.nil? || poverty.zero? || total.nil? || total.zero?
        nil
      else
        ((poverty / total) * 100).round(2)
      end
    [year, value]
  end.sort_by(&:first)

  json.array! [
    {
      name: "Poverty Rate",
      data: @poverty_rate_percentage_data
    }
  ]
end
