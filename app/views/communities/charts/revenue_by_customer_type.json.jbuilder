# app/views/communities/charts/revenue_by_customer_type.json.jbuilder
json.cache! [@latest_sale.reporting_entity&.cache_key_with_version], expires_in: 12.hours do
  json.residential @latest_sale.residential_revenue
  json.commercial @latest_sale.commercial_revenue
end
