json.array! MonthlyGeneration.series_by_year(@grid) do |series|
  json.name series[:name]
  json.data series[:data]
end
