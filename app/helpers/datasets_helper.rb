module DatasetsHelper
  def placeholder_datasets
    [
      { name: "Power Cost Equalization", 
        description: "A program that reduces energy costs for rural residents.", 
        category: "Energy", 
        tags: ["Subsidy", "Cost Reduction", "Rural"], 
        last_updated: "2025-02-28",
        featured: true
      },

      { name: "Fuel Prices", 
        description: "Historical and real-time fuel price data across different regions.", 
        category: "Fuel", 
        tags: ["Gasoline", "Diesel", "Price Trends"], 
        last_updated: "2025-03-01" ,
        featured: true
      },

      { name: "Energy Consumption", 
        description: "Electricity usage data segmented by industry and region.", 
        category: "Electricity", 
        tags: ["Consumption", "Industrial", "Residential"], 
        last_updated: "2025-02-25",
        featured: false
      },

      { name: "Solar Panel Efficiency", 
        description: "Performance metrics of solar panels under different conditions.", 
        category: "Renewables", 
        tags: ["Solar", "Efficiency", "Renewable"], 
        last_updated: "2025-03-03",
        featured: false
      },

      { name: "Wind Energy Output", 
        description: "Wind turbine energy generation data from multiple locations.", 
        category: "Renewables", 
        tags: ["Wind", "Energy Production", "Sustainability"], 
        last_updated: "2025-03-04",
        featured: true
      }
    ]
  end
end
