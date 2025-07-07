module CommunitiesHelper
  def nav_link(text, anchor, parent_section: false)
    link_to text, anchor.to_s, class: "nav-link #{parent_section ? 'fw-semibold' : 'ps-4'} py-1", data: { turbo: false }
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
