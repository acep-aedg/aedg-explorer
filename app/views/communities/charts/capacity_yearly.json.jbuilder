# app/views/communities/charts/capacity_yearly.json.jbuilder
json.cache! [@community.cache_key_with_version, @year], expires_in: 12.hours do
  json.year @year
  json.data @community.capacities.total_mw_by_fuel(@year)
end
