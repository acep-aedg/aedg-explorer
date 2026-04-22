json.cache! [@community, @rates_by_rep_entity, "v1"], expires_in: 12.hours do
  entity_styles = [
    { pointStyle: "circle" },
    { borderDash: [5, 5], pointStyle: "rect" }
  ]

  json.labels @chart_years.map(&:to_s)
  json.datasets do
    @active_sectors.each do |field|
      base_color = ChartsHelper.sector_color(field)
      display_name = field.to_s.gsub("_rate", "").titleize
      display_name = "Blended" if display_name == "Total"

      @rates_by_rep_entity.each_with_index do |(_entity_id, rates), index|
        rates_by_year = rates.index_by(&:year)
        style = entity_styles[index] || { pointStyle: "triangle" }

        data_values = @chart_years.map do |year|
          val = rates_by_year[year]&.public_send(field)
          val&.nonzero?
        end

        next if data_values.all?(&:nil?)

        json.child! do
          json.label           "#{display_name} - #{rates.first.reporting_entity.name}"
          json.data            data_values
          json.borderColor     base_color
          json.backgroundColor base_color.to_opaque(0.7)
          json.pointStyle      style[:pointStyle] if style[:pointStyle]
          json.borderDash      style[:borderDash] if style[:borderDash]
        end
      end
    end
  end
end
