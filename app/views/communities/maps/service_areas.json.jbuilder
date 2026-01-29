# app/views/communities/maps/service_areas.json.jbuilder
json.cache! [@community.service_areas.cache_key_with_version], expires_in: 12.hours do
  json.type "FeatureCollection"
  json.features @community.service_areas.map(&:as_geojson)
end
