module Communities::ChartsHelper
  require 'bigdecimal'
  # structured for chartkick

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
