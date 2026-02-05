# app/views/grids/charts/generation_yearly.json.jbuilder
json.cache! [@grid.cache_key_with_version], expires_in: 12.hours do
  chart_data = YearlyGeneration.series_by_energy_source(@grid).map do |series|
    series[:color] = ChartsHelper.fuel_color(series[:code]).to_opaque
    series.except(:code)
  end
  json.array! chart_data
end
