# app/views/communities/charts/energy_sold.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  if @sales.empty?
    json.array! []
  else
    res_data = {}
    com_data = {}
    tot_data = {}

    @sales.each do |sale|
      year = sale.year.to_s

      res_data[year] = sale.residential_sales
      com_data[year] = sale.commercial_sales
      tot_data[year] = sale.total_sales
    end

    series_list = [
      { name: 'Residential', data: res_data },
      { name: 'Commercial',  data: com_data },
      { name: 'Total',       data: tot_data }
    ]

    json.array! series_list do |series|
      json.name series[:name]
      json.data series[:data]
    end
  end
end
