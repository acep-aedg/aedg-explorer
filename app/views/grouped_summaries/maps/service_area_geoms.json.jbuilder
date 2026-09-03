json.cache! [@parent.service_area_geoms.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @parent.service_area_geoms.map(&:as_geojson)
end
