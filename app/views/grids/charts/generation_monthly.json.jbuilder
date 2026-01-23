# app/views/grids/charts/generation_monthly.json.jbuilder
json.cache! [@grid.cache_key_with_version, @year], expires_in: 12.hours do
  gen_data = MonthlyGeneration.data_by_year(@grid, @year)

  series = [
    {
      name: 'Net Generation (MWh)',
      data: gen_data
    }
  ]

  json.array! series do |s|
    json.name    s[:name]
    json.data    s[:data]
  end
end
