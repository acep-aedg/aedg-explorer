json.cache! [@community.service_area.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features [@community.service_area].compact.map(&:as_geojson)
end
