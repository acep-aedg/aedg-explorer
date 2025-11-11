# app/views/communities/charts/average_sales_rates.json.jbuilder
json.cache! [@community.reporting_entity&.cache_key_with_version], expires_in: 12.hours do
  json.array!(@community.reporting_entity&.sales&.order(year: :asc)&.map do |sale|
    data = {
      'Residential' => sale.residential_rate,
      'Commercial' => sale.commercial_rate,
      'Total' => sale.total_rate
    }.transform_values { |v| v&.to_f&.round(2) }

    { name: sale.year.to_s, data: data }
  end)
end
