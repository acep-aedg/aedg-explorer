# app/views/communities/charts/production_monthly.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.array! MonthlyGeneration.series_by_year(@community) do |series|
    json.name series[:name]
    json.data series[:data]
  end
end
