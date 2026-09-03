json.cache! [@parent.cache_key_with_version, @year], expires_in: 12.hours do
  json.year @year
  json.data @parent.capacities.total_mw_by_fuel(@year)
end
