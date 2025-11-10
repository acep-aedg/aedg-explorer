# app/views/communities/maps/plants.json.jbuilder
json.cache! [@community.plants.cache_key_with_version], expires_in: 12.hours do
  json.type 'FeatureCollection'
  json.features @community.plants.map(&:as_geojson)
end
