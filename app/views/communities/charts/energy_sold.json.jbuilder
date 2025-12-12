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

    has_breakdown = res_data.values.compact.sum.positive? || com_data.values.compact.sum.positive?

    series_list = if has_breakdown
                    [
                      { name: 'Residential', data: res_data, color: '#1f77b4' },
                      { name: 'Commercial',  data: com_data, color: '#ff7f0e' }
                    ]
                  else
                    [
                      { name: 'Total',       data: tot_data, color: '#4A7C8F' }
                    ]
                  end

    json.array! series_list do |series|
      json.name series[:name]
      json.data series[:data]
      json.color series[:color]
    end
  end
end
