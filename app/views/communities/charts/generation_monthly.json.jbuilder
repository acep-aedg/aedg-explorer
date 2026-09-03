json.cache! [@community.cache_key_with_version, @year], expires_in: 12.hours do
  gen_data = @community.monthly_generations.total_mwh_by_year(@year)
  hdd_data = HeatingDegreeDay.data_by_year(@community, @year)

  series = [
    {
      name: "Generation (MWh)",
      data: gen_data,
      library: { yAxisID: "y" }
    }
  ]

  if hdd_data.present?
    series << {
      name: "Heating Degree Days",
      data: hdd_data,
      library: {
        type: "line",
        yAxisID: "y1",
        pointRadius: 3
      }
    }
  end

  json.array! series do |s|
    json.name    s[:name]
    json.data    s[:data]
    json.library s[:library]
  end
end
