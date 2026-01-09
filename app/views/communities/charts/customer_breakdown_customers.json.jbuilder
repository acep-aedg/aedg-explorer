# app/views/communities/charts/customer_breakdown_customers.json.jbuilder

json.cache! [@community.cache_key_with_version, @year], expires_in: 12.hours do
  json.array! [
    ['Residential', @sales.sum { |s| s.residential_customers.to_i }],
    ['Commercial',  @sales.sum { |s| s.commercial_customers.to_i }]
  ]
end
