json.cache! [@parent.service_area_geoms.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.crs do
    json.type "name"
    json.properties do
      json.name "urn:ogc:def:crs:OGC:1.3:CRS84"
    end
  end
  json.features @parent.service_area_geoms.map(&:as_geojson)
end
