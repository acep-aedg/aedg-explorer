# app/views/communities/charts/age_distribution.json.jbuilder
json.cache! [@community.cache_key_with_version, @population_distribution.end_year], expires_in: 12.hours do
  age_groups = [
    { label: "0-4",   key: "under_5" },
    { label: "5-9",   key: "5_9" },
    { label: "10-14", key: "10_14" },
    { label: "15-19", key: "15_19" },
    { label: "20-24", key: "20_24" },
    { label: "25-34", key: "25_34" },
    { label: "35-44", key: "35_44" },
    { label: "45-54", key: "45_54" },
    { label: "55-59", key: "55_59" },
    { label: "60-64", key: "60_64" },
    { label: "65-74", key: "65_74" },
    { label: "75-84", key: "75_84" },
    { label: "85+",   key: "85_plus" }
  ]

  labels = []
  formatted_data = age_groups.map do |group|
    val = @population_distribution[:"e_pop_age_#{group[:key]}"].to_i
    moe = @population_distribution[:"m_pop_age_#{group[:key]}"].to_i

    labels << group[:label]
    {
      x: group[:label],
      y: val,
      yMin: [0, (val - moe).to_i].max,
      yMax: (val + moe).to_i
    }
  end.compact

  json.labels labels

  json.datasets [
    {
      label: "Estimated Population",
      data: formatted_data,
      backgroundColor: "rgba(54, 162, 235, 0.5)",
      borderColor: "rgb(54, 162, 235)",
      borderWidth: 1,
      errorBarColor: "rgb(255, 159, 64)",
      errorBarWhiskerLineWidth: 2,
      errorBarWhiskerSize: 10
    }
  ]
end
