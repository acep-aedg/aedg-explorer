# app/views/grids/charts/production_yearly.json.jbuilder
json.cache! [@grid.cache_key_with_version], expires_in: 12.hours do
  json.year @year
  json.data YearlyGeneration.dataset_by_fuel_for(@grid, @year)
end
