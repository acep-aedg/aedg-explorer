module Communities::ChartsHelper
  require 'bigdecimal'
  # structured for chartkick
  def employment_chart_data(employments)
    [
      {
        name: 'Residents Employed',
        data: employments.map { |e| [e.measurement_year, e.residents_employed] }
      },
      {
        name: 'Unemployment Insurance Claimants',
        data: employments.map { |e| [e.measurement_year, e.unemployment_insurance_claimants] }
      }
    ]
  end

  def age_group_estimates_with_moe_data(community)
    population_age_sexes = PopulationAgeSex.most_recent_for(community.fips_code).ordered

    age_groups = [
      { label: '0-4', key: 'under_5' },
      { label: '5-9', key: '5_9' },
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
      { label: '85+', key: '85_plus' }
    ]

    estimate_data = {}
    moe_data = {}

    age_groups.each do |group|
      estimate = population_age_sexes.sum("e_pop_age_#{group[:key]}").to_i
      moe = population_age_sexes.sum("m_pop_age_#{group[:key]}").to_i

      if estimate.positive?
        estimate_data[group[:label]] = estimate
        moe_data[group[:label]] = moe
      end
    end

    # Return data for Chartkick with 2 series
    [
      { name: 'Estimated Population', data: estimate_data },
      { name: 'Margin of Error', data: moe_data }
    ]
  end

  def fuel_prices_by_season_chart_data(fuel_prices, price_type: nil)
    filtered = fuel_prices.select { |fp| fp.price_type.to_s.downcase == price_type.to_s.downcase }

    return [] if filtered.empty?

    years = filtered.map(&:reporting_year).uniq.sort

    # Fixed category order ensures consistent series across years
    categories = ['Winter Gasoline', 'Winter Heating Fuel', 'Summer Gasoline', 'Summer Heating Fuel']

    # Lookup: [year, category] => price Ex: [2024, "Winter Gasoline"] => 6.94
    price_map = filtered.each_with_object({}) do |fp, hash|
      next if fp.price.blank?

      label = "#{fp.reporting_season.to_s.capitalize} #{fp.fuel_type.to_s.titleize}"
      hash[[fp.reporting_year, label]] = BigDecimal(fp.price.to_s)
    end

    categories.map do |label|
      {
        name: label,
        data: years.index_with { |year| price_map[[year, label]] }
      }
    end
  end
end
