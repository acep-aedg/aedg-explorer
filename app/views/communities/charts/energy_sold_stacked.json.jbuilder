sales = @community.reporting_entity&.sales&.order(year: :asc) || []

residential_data = {}
commercial_data  = {}

sales.each do |sale|
  year = sale.year.to_s

  # Residential
  if (val = sale.residential_sales).present?
    residential_data[year] = val.to_f.round(2)
  end

  # Commercial
  if (val = sale.commercial_sales).present?
    commercial_data[year] = val.to_f.round(2)
  end
end

series = [
  { name: 'Residential', data: residential_data },
  { name: 'Commercial',  data: commercial_data }
]

# 4. Render
json.array! series do |s|
  json.name s[:name]
  json.data s[:data]
end
