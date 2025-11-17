# app/views/communities/charts/gender_distribution.json.jbuilder
json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  if @population_distribution.nil?
    json.empty!
  else
    male_estimate   = @population_distribution.e_pop_male
    female_estimate = @population_distribution.e_pop_female
    male_moe        = @population_distribution.m_pop_male
    female_moe      = @population_distribution.m_pop_female

    json.set! "Male (±#{male_moe})", male_estimate
    json.set! "Female (±#{female_moe})", female_estimate
  end
end
