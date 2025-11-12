# app/views/communities/charts/gender_distribution.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  population = @community.population_age_sexes.most_recent_for(@community.fips_code).first

  male_estimate   = population.e_pop_male
  female_estimate = population.e_pop_female
  male_moe        = population.m_pop_male
  female_moe      = population.m_pop_female

  json.set! "Male (±#{male_moe})", male_estimate
  json.set! "Female (±#{female_moe})", female_estimate
end
