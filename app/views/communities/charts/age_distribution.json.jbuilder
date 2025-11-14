# app/views/communities/charts/age_distribution.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  age_groups = [
    { label: '0-4',   key: 'under_5' },
    { label: '5-9',   key: '5_9' },
    { label: '10-14', key: '10_14' },
    { label: '15-19', key: '15_19' },
    { label: '20-24', key: '20_24' },
    { label: '25-34', key: '25_34' },
    { label: '35-44', key: '35_44' },
    { label: '45-54', key: '45_54' },
    { label: '55-59', key: '55_59' },
    { label: '60-64', key: '60_64' },
    { label: '65-74', key: '65_74' },
    { label: '75-84', key: '75_84' },
    { label: '85+',   key: '85_plus' }
  ]

  estimate_data = {}
  moe_data = {}

  age_groups.each do |group|
    estimate = @population_distribution[:"e_pop_age_#{group[:key]}"].to_i
    moe      = @population_distribution[:"m_pop_age_#{group[:key]}"].to_i

    if estimate.positive?
      estimate_data[group[:label]] = estimate
      moe_data[group[:label]]      = moe
    end
  end

  json.array! [
    { name: 'Estimated Population', data: estimate_data },
    { name: 'Margin of Error',      data: moe_data }
  ]
end
