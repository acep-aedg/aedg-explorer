# app/views/communities/charts/energy_sold.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  if @sales.empty?
    json.array! []
  else
    res_data = {}
    com_data = {}

    @sales.each do |sale|
      year = sale.year.to_s
      res_data[year] = sale.residential_sales
      com_data[year] = sale.commercial_sales
    end

    series = [
      { name: "Residential", data: res_data },
      { name: "Commercial",  data: com_data }
    ]

    json.array! series do |s|
      json.name s[:name]
      json.data s[:data]
    end
  end
end
