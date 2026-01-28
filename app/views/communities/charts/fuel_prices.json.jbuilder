# app/views/communities/charts/fuel_prices.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  
  category_colors = {
    "Winter Gasoline"     => ChartsHelper.color(:light_blue),
    "Winter Heating Fuel"  => ChartsHelper.color(:dark_blue),
    "Summer Gasoline"     => ChartsHelper.color(:light_green),
    "Summer Heating Fuel"  => ChartsHelper.color(:dark_green),
    "Heating Degree Days" => ChartsHelper.color(:orange)
  }
  
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
    active_categories = categories.select do |label|
      years.any? { |year| price_map[[year, label]].present? }
    end

    series = active_categories.map do |label|
      {
        name: label,
        data: years.index_with { |year| price_map[[year, label]] },
        color: category_colors[label],
        library: {
          type: "bar",
          yAxisID: "y",
          prefix: "$ "
        }
      }
    end

    # --- Line series for Heating Degree Days -> right axis "y1" ---
    hdd_series = if @community.show_heating_degree_days?
                   hdd_by_year = @heating_degree_days
                                 .group_by(&:year)
                                 .transform_values { |rows| rows.sum { |r| r.heating_degree_days.to_f } }
                   {
                     name: "Heating Degree Days",
                     data: years.index_with { |year| hdd_by_year[year] },
                     color: ChartsHelper.color(:orange),
                     library: {
                       type: "line",
                       yAxisID: "y1",
                       pointRadius: 3
                     }
                   }
                 end

    # Merge and remove nil if show_heating_degree_days? was false
    json.array!((series + [hdd_series]).compact) do |s|
      json.name    s[:name]
      json.data    s[:data]
      json.color   s[:color]
      json.library s[:library]
    end
  end
end
