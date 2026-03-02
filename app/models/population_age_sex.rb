class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  # Scope to order by start year if needed
  scope :ordered, -> { order(start_year: :desc) }

  scope :with_age_estimates, -> { where(age_estimate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :with_sex_estimates, -> { where(sex_estimate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }

  def self.sex_estimate_fields
    %i[
      e_pop_male
      e_pop_female
      m_pop_male
      m_pop_female
    ]
  end

  def self.age_estimate_fields
    %i[
      e_pop_age_under_5
      e_pop_age_5_9
      e_pop_age_10_14
      e_pop_age_15_19
      e_pop_age_20_24
      e_pop_age_25_34
      e_pop_age_35_44
      e_pop_age_45_54
      e_pop_age_55_59
      e_pop_age_60_64
      e_pop_age_65_74
      e_pop_age_75_84
      e_pop_age_85_plus
      m_pop_age_under_5
      m_pop_age_5_9
      m_pop_age_10_14
      m_pop_age_15_19
      m_pop_age_20_24
      m_pop_age_25_34
      m_pop_age_35_44
      m_pop_age_45_54
      m_pop_age_55_59
      m_pop_age_60_64
      m_pop_age_65_74
      m_pop_age_75_84
      m_pop_age_85_plus
    ]
  end

  def self.sex_values_by_period
    order(end_year: :asc).map do |r|
      {
        period: "#{r.start_year}–#{r.end_year}",
        male_estimate: r.e_pop_male.to_i,
        male_moe: r.m_pop_male.to_i,
        female_estimate: r.e_pop_female.to_i,
        female_moe: r.m_pop_female.to_i
      }
    end
  end
end
