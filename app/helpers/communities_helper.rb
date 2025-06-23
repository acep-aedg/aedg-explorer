module CommunitiesHelper
  def nav_link(text, anchor, parent_section: false)
    link_to text, anchor.to_s, class: "nav-link #{parent_section ? 'fw-semibold' : 'ps-4'} py-1", data: { turbo: false }
  end

  # Electricity section visibility methods
  def show_utilities?(community)
    show_main_utility?(community) || show_grid_utilities?(community)
  end

  def show_grid_utilities?(community)
    community.grid&.reporting_entities&.exists?
  end

  def show_main_utility?(community)
    community.reporting_entity.present?
  end

  def show_rates?(community)
    community.electric_rates&.any? do |rate|
      rate.residential_rate || rate.commercial_rate || rate.industrial_rate
    end
  end

  def show_production?(community)
    show_monthly_generation?(community) || show_yearly_generation?(community)
  end

  def show_yearly_generation?(community)
    community.grid&.yearly_generations&.exists?
  end

  def show_monthly_generation?(community)
    community.grid&.monthly_generations&.exists?
  end

  def show_capacity?(community)
    community.grid&.capacities&.exists?
  end

  def show_sales_revenue_customers?(community)
    community.reporting_entity&.sales&.exists?
  end

  # If any sub-sections are visible, show the parent section
  def show_electricity_section?(community)
    show_utilities?(community) ||
      show_rates?(community) ||
      show_production?(community) ||
      show_capacity?(community) ||
      show_sales_revenue_customers?(community)
  end

  # Prices section visibility methods
  def show_fuel_prices?(community)
    community.fuel_prices.exists?
  end

  # If any sub-sections are visible, show the parent section
  def show_prices_section?(community)
    show_fuel_prices?(community)
  end

  # Background section visibility methods
  def show_transportation?(community)
    community.transportation.present?
  end

  def show_election_districts?(community)
    show_senate_districts?(community) || show_house_districts?(community)
  end

  def show_senate_districts?(community)
    community.senate_districts.any?
  end

  def show_house_districts?(community)
    community.house_districts.any?
  end

  def show_population?(community)
    community.population_age_sexes.exists?
  end

  # If any sub-sections are visible, show the parent section
  def show_background_section?(community)
    show_transportation?(community) ||
      show_election_districts?(community) ||
      show_population?(community)
  end
end
