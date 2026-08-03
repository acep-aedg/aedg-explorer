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

  def community_service_area_label(community)
    community.local_service_area? ? "Local Service Area" : "Utility Service Area"
  end

  def community_utilities_map_buttons(community)
    [
      if community.local_service_area?
        {
          label: community_service_area_label(community),
          url: service_area_geom_community_maps_path(community),
          icon: "bounding-box",
          id: "service-area-geom"
        }
      end,
      if community.service_areas?
        {
          label: "Utility Service Area",
          url: service_area_community_maps_path(community),
          icon: "bounding-box",
          id: "service-area"
        }
      end,
      if community.plants?
        {
          label: "Power Plants",
          url: plants_community_maps_path(community),
          icon: "building",
          id: "plant-points"
        }
      end
    ].compact
  end

  def community_legislative_map_buttons(community)
    [
      if community.house_districts?
        {
          label: "House Districts",
          url: house_districts_community_maps_path(community),
          icon: "house-fill",
          id: "house-districts"
        }
      end,
      if community.senate_districts?
        {
          label: "Senate Districts",
          url: senate_districts_community_maps_path(community),
          icon: "bank",
          id: "senate-districts"
        }
      end
    ].compact
  end

  def community_bulk_fuel_map_buttons(community)
    [
      if community.bulk_fuel_facilities?
        {
          label: "Bulk Fuel Facilities",
          url: bulk_fuel_facilities_community_maps_path(community),
          icon: "building",
          id: "bulk-fuel-facilities-points"
        }
      end
    ].compact
  end
end
