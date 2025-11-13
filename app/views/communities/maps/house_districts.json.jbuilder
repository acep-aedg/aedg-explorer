# app/views/communities/maps/house_districts.json.jbuilder
json.cache! [@community.house_districts.cache_key_with_version], expires_in: 12.hours do
  json.type 'FeatureCollection'
  json.features @community.house_districts.map(&:as_geojson)
end
