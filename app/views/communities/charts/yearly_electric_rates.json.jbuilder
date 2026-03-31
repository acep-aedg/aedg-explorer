json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.labels @grouped.keys.map(&:to_s)

  json.datasets @active_fields do |field|
    data = @grouped.map do |year, records|
      values = records.map { |r| r.public_send(field)&.to_f }.compact

      case values.size
      when 0
        nil
      when 1
        values.first.nonzero?
      else
        ElectricRateWeightedAverage.call(records, year, field)
      end
    end

    next if data.all?(&:nil?)

    base_color = ChartsHelper.sector_color(field)

    is_average = field.to_s == "total_rate"
    display_name = is_average ? "Average" : field.to_s.gsub("_rate", "").titleize

    json.label           display_name
    json.data            data
    json.borderColor     base_color
    json.backgroundColor base_color.to_opaque(0.7)

    json.borderDash [5, 5] if is_average
  end
end
