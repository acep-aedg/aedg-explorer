module Communities::ChartsHelper
  # structured for chartkick
  def employment_chart_data(employments)
    [
      {
        name: "Residents Employed",
        data: employments.map { |e| [e.measurement_year, e.residents_employed] }
      },
      {
        name: "Unemployment Insurance Claimants",
        data: employments.map { |e| [e.measurement_year, e.unemployment_insurance_claimants] }
      }
    ]
  end

  def age_group_estimates_with_moe_data(community)
    population_age_sexes = PopulationAgeSex.most_recent_for(community.fips_code).ordered

    age_groups = [
      { label: "0-4", key: "under_5" },
      { label: "5-9", key: "5_9" },
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
      { label: "85+", key: "85_plus" }
    ]

    estimate_data = {}
    moe_data = {}

    age_groups.each do |group|
      estimate = population_age_sexes.sum("e_pop_age_#{group[:key]}").to_i
      moe = population_age_sexes.sum("m_pop_age_#{group[:key]}").to_i

      if estimate > 0
        estimate_data[group[:label]] = estimate
        moe_data[group[:label]] = moe
      end
    end

    # Return data for Chartkick with 2 series
    [
      { name: "Estimated Population", data: estimate_data },
      { name: "Margin of Error", data: moe_data }
    ]
  end

  def gender_distribution_chart_data(community)
    population = community.population_age_sexes.most_recent_for(community.fips_code)

    male_estimate = population.sum(:e_pop_male)
    female_estimate = population.sum(:e_pop_female)

    male_moe = population.sum(:m_pop_male)
    female_moe = population.sum(:m_pop_female)

    {
      "Male (±#{male_moe})" => male_estimate,
      "Female (±#{female_moe})" => female_estimate
    }
  end
end
