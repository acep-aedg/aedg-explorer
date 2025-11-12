# app/views/communities/maps/bulk_fuel_facilities.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.type 'FeatureCollection'
  json.features @community.bulk_fuel_facilities.map(&:as_geojson)
end
