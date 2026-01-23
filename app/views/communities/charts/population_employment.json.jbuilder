# app/views/communities/charts/population_employment.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  employments = @community.employments.order(:measurement_year)

  json.array! [
    { name: "Residents Employed",
      data: employments.pluck(:measurement_year, :residents_employed) },
    { name: "Unemployment Insurance Claimants",
      data: employments.pluck(:measurement_year, :unemployment_insurance_claimants) }
  ]
end
