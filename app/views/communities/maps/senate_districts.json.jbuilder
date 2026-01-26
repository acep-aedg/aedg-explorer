# app/views/communities/maps/senate_districts.json.jbuilder
json.cache! [@community.senate_districts.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @community.senate_districts.map(&:as_geojson)
end
