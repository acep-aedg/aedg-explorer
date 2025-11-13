# app/views/communities/charts/sales_by_customer_type.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.residential @latest_sale.residential_sales
  json.commercial  @latest_sale.commercial_sales
end
