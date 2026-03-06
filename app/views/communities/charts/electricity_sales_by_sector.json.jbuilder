# app/views/communities/charts/energy_sold.json.jbuilder
json.array! YearlySale.sales_fields do |field|
  sales = @community.yearly_sales.order(:year)

  data_hash = sales.each_with_object({}) do |sale, hash|
    val = sale.public_send(field)
    hash[sale.year.to_s] = val&.to_s
  end

  # Skip this sector if there is no data for any year
  next if data_hash.values.all?(&:nil?)

  json.name "#{field.to_s.gsub('_sales', '').humanize} MWh Sold"
  json.data data_hash
end
