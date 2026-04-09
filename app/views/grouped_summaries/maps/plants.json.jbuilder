json.cache! [@parent.plants.cache_key_with_version, "v_gold_hash_1"], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @parent.plants.with_location.map(&:as_geojson)
end
