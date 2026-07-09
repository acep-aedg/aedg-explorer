json.cache! [@community.senate_districts.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.crs do
    json.type "name"
    json.properties do
      json.name "urn:ogc:def:crs:OGC:1.3:CRS84"
    end
  end
  json.features @community.senate_districts.map(&:as_geojson)
end
