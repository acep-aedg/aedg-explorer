module CommunitiesHelper
  def community_navigation_tabs(community)
    [
      { label: "General", path: general_community_path(community), visible: true },
      { label: "Power Generation", path: power_generation_community_path(community), visible: community.power_generation? },
      { label: "Electricity Rates & Sales", path: electric_rates_sales_community_path(community), visible: community.electricity_sales_rates? },
      { label: "Fuel", path: fuel_community_path(community), visible: community.fuel? },
      { label: "Demographics", path: demographics_community_path(community), visible: community.demographics? },
      { label: "Income", path: income_community_path(community), visible: community.income? }
    ].select { |tab| tab[:visible] }
  end
end
