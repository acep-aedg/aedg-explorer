# app/views/communities/charts/sales_by_customer_type.json.jbuilder

json.cache! [@community.cache_key_with_version, @year], expires_in: 12.hours do
  json.array! [
    ["Residential", @sales.sum { |s| s.residential_sales.to_f }],
    ["Commercial",  @sales.sum { |s| s.commercial_sales.to_f }]
  ]
end
