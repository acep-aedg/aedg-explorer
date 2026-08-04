module GroupedSummaries
  module JumpLinkHelper
    def grouped_summary_general_jump_links
      [
        { title: "Overview", anchor: "#overview", icon: "globe" }
      ]
    end

    def grouped_summary_power_generation_jump_links(parent)
      [
        ({ title: "Utilities", anchor: "#utilities", icon: "buildings" } if parent.utilities?),
        ({ title: "Generation", anchor: "#generation", icon: "building-gear" } if parent.generation?),
        ({ title: "Capacity", anchor: "#capacity", icon: "lightning-fill" } if parent.capacities?)
      ].compact
    end

    def grouped_summary_electric_rates_sales_jump_links(parent)
      [
        ({ title: "Revenue", anchor: "#revenue", icon: "cash-coin" } if parent.yearly_electricity_revenues?),
        ({ title: "Consumption", anchor: "#consumption", icon: "lightning-charge" } if parent.yearly_electricity_sales?)
      ].compact
    end
  end
end
