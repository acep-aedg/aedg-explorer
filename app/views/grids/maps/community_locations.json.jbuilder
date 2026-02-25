json.cache! [@grid.communities.cache_key_with_version, "v_gold_1"], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @grid.communities.with_location.map(&:as_geojson)
end