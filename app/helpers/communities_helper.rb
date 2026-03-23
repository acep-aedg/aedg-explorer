module CommunitiesHelper
  def community_navigation_tabs(community)
    [
      { label: "General", path: general_community_path(community), visible: true },
      { label: "Power Generation", path: power_generation_community_path(community), visible: community.show_power_generation_tab? },
      { label: "Electricity Rates & Sales", path: electric_rates_sales_community_path(community), visible: community.show_sales_rates_tab? },
      { label: "Fuel", path: fuel_community_path(community), visible: community.show_fuel_tab? },
      { label: "Demographics", path: demographics_community_path(community), visible: community.show_demographics_tab? },
      { label: "Income", path: income_community_path(community), visible: community.show_income? }
    ].select { |tab| tab[:visible] }
  end
end
