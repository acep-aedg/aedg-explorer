json.cache! [@grid.plants.cache_key_with_version, "v_gold_hash_1"], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @grid.plants.where.not(location: nil).map(&:as_geojson)
end