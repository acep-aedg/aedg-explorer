json.cache! [@parent.plants.cache_key_with_version, "v_gold_hash_1"], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.crs do
    json.type "name"
    json.properties do
      json.name "urn:ogc:def:crs:OGC:1.3:CRS84"
    end
  end
  json.features @parent.plants.with_location.map(&:as_geojson)
end
