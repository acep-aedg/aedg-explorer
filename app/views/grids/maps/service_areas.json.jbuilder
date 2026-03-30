json.cache! [@grid.service_areas.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @grid.service_areas.distinct.map(&:as_geojson)
end
