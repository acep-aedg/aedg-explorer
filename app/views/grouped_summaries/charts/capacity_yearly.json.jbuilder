# app/views/grids/charts/capacity_yearly.json.jbuilder
json.cache! [@parent.cache_key_with_version, @year], expires_in: 12.hours do
  json.year @year
  json.data Capacity.dataset_by_fuel_for(@parent, @year)
end
