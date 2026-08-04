module Communities
  module JumpLinkHelper
    def community_general_jump_links(community)
      [
        { title: "Geography", anchor: "#geography", icon: "map" },
        ({ title: "Transportation", anchor: "#transportation", icon: "truck" } if community.transportation?),
        ({ title: "Legislative Districts", anchor: "#legislative-districts", icon: "bank" } if community.legislative_districts?)
      ].compact
    end

    def community_power_generation_jump_links(community)
      [
        ({ title: "Utilities", anchor: "#utilities", icon: "buildings" } if community.utilities?),
        ({ title: "Generation", anchor: "#generation", icon: "building-gear" } if community.generation?),
        ({ title: "Capacity", anchor: "#capacity", icon: "lightning-fill" } if community.capacities?)
      ].compact
    end

    def community_electric_rates_sales_jump_links(community)
      [
        ({ title: "Consumption", anchor: "#consumption", icon: "lightning-charge" } if community.yearly_electricity_sales?),
        ({ title: "Revenue", anchor: "#revenue", icon: "cash-coin" } if community.yearly_electricity_revenues?),
        ({ title: "Customers", anchor: "#customers", icon: "people" } if community.yearly_electricity_customers?),
        ({ title: "Rates", anchor: "#rates", icon: "coin" } if community.yearly_electric_rates?)
      ].compact
    end

    def community_fuel_jump_links(community)
      [
        ({ title: "Fuel Prices", anchor: "#fuel-prices", icon: "coin" } if community.fuel_prices?),
        ({ title: "Bulk Fuel", anchor: "#bulk-fuel-facilities", icon: "fuel-pump" } if community.bulk_fuel_facilities?)
      ].compact
    end

    def community_demographics_jump_links(community)
      [
        ({ title: "Population", anchor: "#population", icon: "people-fill" } if community.population_age_sexes?),
        ({ title: "Employment", anchor: "#employment", icon: "briefcase-fill" } if community.employment?)
      ].compact
    end
  end
end
