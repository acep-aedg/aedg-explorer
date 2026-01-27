# app/views/communities/charts/production_yearly.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  chart_data = YearlyGeneration.yearly_series_by_energy_source(@community).map do |series|
    series[:color] = ChartsHelper.fuel_color(series[:code]).to_opaque
    series.except(:code)
  end

  json.array! chart_data
end
