json.labels @grouped.keys.map(&:to_s)

json.datasets YearlySale.sectors do |sector|
  # Calculate (Sum of Sales / Sum of Customers) for each year
  data_values = @grouped.map do |_year, records|
    YearlySale.consumption_per_customer(records, sector)
  end

  # Skip this sector if there is no data (all zeros)
  next if data_values.compact.empty?

  # Determine Color
  base_color = ChartsHelper.sector_color(sector)

  json.label           sector.to_s.titleize
  json.data            data_values
  json.backgroundColor base_color.to_opaque(0.7)
  json.borderColor     base_color
end
