# app/views/grids/maps/plants.json.jbuilder
json.cache! [@grid.plants.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @grid.plants.map(&:as_geojson)
end
