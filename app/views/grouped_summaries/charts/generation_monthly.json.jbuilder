json.cache! [@parent.cache_key_with_version, @year], expires_in: 12.hours do
  gen_data = @parent.monthly_generations.total_mwh_by_year(@year)

  series = [
    {
      name: "Generation (MWh)",
      data: gen_data
    }
  ]

  json.array! series do |s|
    json.name    s[:name]
    json.data    s[:data]
  end
end
