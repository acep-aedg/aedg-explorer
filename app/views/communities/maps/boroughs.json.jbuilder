json.cache! [@community.borough.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features [@community.borough].compact.map(&:as_geojson)
end
