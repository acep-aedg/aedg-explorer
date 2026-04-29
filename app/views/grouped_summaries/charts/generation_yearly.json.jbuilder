json.cache! [@parent.plants.size], expires_in: 12.hours do
  chart_data = @parent.yearly_generations.total_mwh_by_energy_source.map do |series|
    series[:color] = ChartsHelper.fuel_color(series[:code]).to_opaque
    series.except(:code)
  end
  json.array! chart_data
end
