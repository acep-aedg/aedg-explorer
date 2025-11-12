# app/views/grid/maps/community_locations.json.jbuilder
json.cache! [@grid.communities.cache_key_with_version], expires_in: 12.hours do
  json.type 'FeatureCollection'
  json.features @grid.communities.with_location do |c|
    feature = c.as_geojson
    feature[:properties][:path] = community_path(c)
    json.merge! feature
  end
end
