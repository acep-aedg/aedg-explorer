json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  sector_colors = {
    "residential" => color(:blue),
    "commercial" => color(:orange),
    "industrial" => color(:dark_green)
  }

  entity_styles = [
    { borderDash: [],        pointStyle: "circle",   borderWidth: 3 },
    { borderDash: [6, 6],    pointStyle: "rect",     borderWidth: 2 },
    { borderDash: [2, 4],    pointStyle: "triangle", borderWidth: 2 }
  ]

  fallback_style = { borderDash: [10, 4, 2, 4], pointStyle: "cross", borderWidth: 2 }

  chart_data = []

  rates = @community.electric_rates.includes(:reporting_entity)
  valid_rates = rates.select { |r| r.reporting_entity.present? }

  if valid_rates.any?
    grouped_by_entity = valid_rates.group_by(&:reporting_entity)

    sorted_entities = grouped_by_entity.keys.sort_by(&:name)

    sorted_entities.each_with_index do |entity, index|
      entity_rates = grouped_by_entity[entity]
      style = entity_styles[index] || fallback_style

      %w[residential commercial industrial].each do |sector|
        method_name = "#{sector}_rate"

        points = entity_rates.map { |r| [r.year.to_s, r.send(method_name)] }
                             .reject { |pt| pt[1].nil? }
                             .sort_by { |pt| pt[0] }

        next unless points.any?

        chart_data << {
          name: "#{entity.name} - #{sector.titleize}",
          data: points,
          color: sector_colors[sector],
          dataset: {
            tension: 0.3,
            borderDash: style[:borderDash],
            pointStyle: style[:pointStyle],
            borderWidth: style[:borderWidth]
          }
        }
      end
    end
  end

  json.array! chart_data
end
