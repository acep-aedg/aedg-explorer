sector_fields = YearlySale.sales_fields - YearlySale.total_fields
json.labels @grouped.keys.map(&:to_s)
json.datasets sector_fields do |field|
  data = @grouped.map do |_year, records|
    records.sum { |r| r.public_send(field).to_f }
  end

  # Skip this sector if there is no data (all zeros)
  next if data.all?(&:zero?)

  # Determine Color
  base_color = ChartsHelper.sector_color(field)

  # Dataset structure
  json.label           "#{field.to_s.gsub('_sales_mwh', '').titleize}"
  json.data            data
  json.backgroundColor base_color.to_opaque(0.7)
  json.borderColor     base_color
end
