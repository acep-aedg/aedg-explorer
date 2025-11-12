# app/views/grids/charts/production_monthly.json.jbuilder
json.cache! [@grid.cache_key_with_version], expires_in: 12.hours do
  json.array! MonthlyGeneration.series_by_year(@grid) do |series|
    json.name series[:name]
    json.data series[:data]
  end
end
