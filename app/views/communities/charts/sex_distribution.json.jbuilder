# app/views/communities/charts/sex_distribution.json.jbuilder
json.cache! [@community.cache_key_with_version, "sex_distribution"], expires_in: 12.hours do
  json.array! @community.population_age_sexes.with_sex_estimates.sex_values_by_period
end
