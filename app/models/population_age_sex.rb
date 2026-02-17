class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  # Scope to order by start year if needed
  scope :ordered, -> { order(start_year: :desc) }
  
  scope :with_age_estimates, -> { where(age_estimate_fields.map { |f| "#{f} > 0" }.join(" OR ")) }
  scope :with_moe_age_estimates, -> { where(moe_age_estimate_fields.map { |f| "#{f} > 0" }.join(" OR ")) }
  scope :with_gender_estimates, -> { where(gender_estimate_fields.map { |f| "#{f} > 0" }.join(" OR ")) }
  scope :with_moe_gender_estimates, -> { where(moe_gender_estimate_fields.map { |f| "#{f} > 0" }.join(" OR ")) }

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
    ]
  end

  def self.moe_age_estimate_fields
    %i[
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

  def self.gender_estimate_fields
    %i[
      e_pop_male
      e_pop_female
    ]
  end

  def self.moe_gender_estimate_fields
    %i[
      m_pop_male
      m_pop_female
    ]
  end

end
