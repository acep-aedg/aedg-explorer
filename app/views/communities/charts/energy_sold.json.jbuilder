# app/views/communities/charts/energy_sold.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  if @latest_sale.nil?
    json.array! []
  else
    series_list = [
      { name: 'Residential', data: @latest_sale.residential_sales },
      { name: 'Commercial',  data: @latest_sale.commercial_sales },
      { name: 'Total',       data: @latest_sale.total_sales }
    ]

    json.array! series_list do |series|
      json.name series[:name]
      json.data({ @latest_sale.year.to_s => series[:data] })
    end
  end
end
