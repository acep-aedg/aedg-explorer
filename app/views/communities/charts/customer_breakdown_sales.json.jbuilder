# app/views/communities/charts/sales_by_customer_type.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  json.Residential @latest_sale.residential_sales
  json.Commercial  @latest_sale.commercial_sales
end
