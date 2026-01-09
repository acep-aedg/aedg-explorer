# app/views/communities/charts/customer_breakdown_revenue.json.jbuilder

json.cache! [@community.cache_key_with_version, @year], expires_in: 12.hours do
  json.array! [
    ['Residential', @sales.sum { |s| s.residential_revenue.to_f }],
    ['Commercial',  @sales.sum { |s| s.commercial_revenue.to_f }]
  ]
end