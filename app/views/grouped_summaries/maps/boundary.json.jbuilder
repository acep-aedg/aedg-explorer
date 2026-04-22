json.cache! [@parent, "boundary"] do
  json.type "FeatureCollection"
  json.features [@parent.as_geojson].compact
end
