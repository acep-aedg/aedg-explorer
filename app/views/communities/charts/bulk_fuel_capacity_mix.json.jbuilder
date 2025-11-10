json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.merge! @capacity_mix # {"Gasoline":41000,"Diesel":600000,"Jet Fuel":201000}
end
