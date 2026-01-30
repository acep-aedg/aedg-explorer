# app/views/grids/maps/service_area_geoms.json.jbuilder
json.cache! [@grid.service_area_geoms.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @grid.service_area_geoms.distinct.map(&:as_geojson)
end
