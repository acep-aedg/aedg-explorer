module CommunitiesHelper
  def community_navigation_tabs(community)
    [
      { label: "General", path: general_community_path(community) },
      ({ label: "Power Generation", path: power_generation_community_path(community) } if community.power_generation?),
      ({ label: "Electricity Rates & Sales", path: electric_rates_sales_community_path(community) } if community.electricity_sales_rates?),
      ({ label: "Fuel", path: fuel_community_path(community) } if community.fuel?),
      ({ label: "Demographics", path: demographics_community_path(community) } if community.demographics?),
      ({ label: "Income", path: income_community_path(community) } if community.income?)
    ].compact
  end

  def community_service_area_label(community)
    community.local_service_area? ? "Local Service Area" : "Utility Service Area"
  end
end
