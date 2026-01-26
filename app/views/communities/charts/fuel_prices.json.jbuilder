# app/views/communities/charts/fuel_prices.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  # Normalize optional filter
  price_type = @price_type.to_s.downcase.presence

  filtered =
    if price_type
      @fuel_prices.select { |fp| fp.price_type.to_s.downcase == price_type }
    else
      @fuel_prices.to_a
    end

  if filtered.empty?
    json.array! []
  else
    years = filtered.map(&:reporting_year).uniq.sort

    categories = [
      "Winter Gasoline",
      "Winter Heating Fuel",
      "Summer Gasoline",
      "Summer Heating Fuel"
    ]

    # [year, category] -> price
    price_map = filtered.each_with_object({}) do |fp, hash|
      next if fp.price.blank?

      label = "#{fp.reporting_season.to_s.capitalize} #{fp.fuel_type.to_s.titleize}"
      hash[[fp.reporting_year, label]] = fp.price.to_f
    end

    # --- Bar series for fuel prices -> left axis "y" ---
    series = categories.map do |label|
      {
        name: label,
        data: years.index_with { |year| price_map[[year, label]] },
        library: {
          type: "bar",
          yAxisID: "y",
          suffix: " $"
        }
      }
    end

    # --- Line series for Heating Degree Days -> right axis "y1" ---
    hdd_by_year = @heating_degree_days
                  .group_by(&:year)
                  .transform_values { |rows| rows.sum { |r| r.heating_degree_days.to_f } }

    hdd_series = {
      name: "Heating Degree Days",
      data: years.index_with { |year| hdd_by_year[year] },
      library: {
        type: "line",
        yAxisID: "y1",
        pointRadius: 3
      }
    }

    json.array!(series + [hdd_series]) do |s|
      json.name    s[:name]
      json.data    s[:data]
      json.library s[:library]
    end
  end
end
