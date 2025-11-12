# app/views/communities/charts/average_sales_rates.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.array!(@community.reporting_entity&.sales&.order(year: :asc)&.map do |sale|
    data = {
      'residential' => sale.residential_rate,
      'commercial' => sale.commercial_rate,
      'total' => sale.total_rate
    }.transform_values { |v| v&.to_f&.round(2) }

    { name: sale.year.to_s, data: data }
  end)
end
