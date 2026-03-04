# app/views/communities/charts/age_distribution.json.jbuilder
json.cache! [@community.cache_key_with_version, "age_distribution", @end_year], expires_in: 12.hours do
  json.array! @community.population_age_sexes.with_age_estimates.age_values_by_period(@end_year)
end
