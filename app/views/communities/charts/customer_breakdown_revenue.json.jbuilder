# app/views/communities/charts/revenue_by_customer_type.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.Residential @latest_sale.residential_revenue
  json.Commercial @latest_sale.commercial_revenue
end
