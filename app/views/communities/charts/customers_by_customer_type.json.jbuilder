# app/views/communities/charts/customers_by_customer_type.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.residential @latest_sale.residential_customers
  json.commercial @latest_sale.commercial_customers
end
