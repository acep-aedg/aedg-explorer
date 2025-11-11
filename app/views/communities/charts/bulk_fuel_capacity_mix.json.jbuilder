# app/views/communities/charts/bulk_fuel_capacity_mix.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.merge! @community.bulk_fuel_facilities.capacity_by_fuel_type # {"Gasoline":41000,"Diesel":600000,"Jet Fuel":201000}
end
