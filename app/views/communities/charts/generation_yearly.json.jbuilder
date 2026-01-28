# app/views/communities/charts/generation_yearly.json.jbuilder

chart_data = YearlyGeneration.yearly_series_by_energy_source(@community).map do |series|
  series[:color] = ChartsHelper.fuel_color(series[:code]).to_opaque
  series.except(:code)
end

json.array! chart_data
