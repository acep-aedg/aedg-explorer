json.array! MonthlyGeneration.series_by_year(@community) do |series|
  json.name series[:name]
  json.data series[:data]
end
