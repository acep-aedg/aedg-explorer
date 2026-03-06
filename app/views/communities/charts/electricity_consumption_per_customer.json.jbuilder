usage_per_customer_rates = @community.yearly_sales.usage_per_customer_rates

json.labels(usage_per_customer_rates.pluck(:year))

json.datasets YearlySale.sectors do |sector|
  data = usage_per_customer_rates.map { |d| d[sector] }

  next if data.compact.empty?

  json.label sector.to_s.humanize
  json.data data
end
