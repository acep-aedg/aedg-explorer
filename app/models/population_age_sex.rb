class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  default_scope { order(end_year: :desc) }

  scope :with_age_estimates, -> { where(age_estimate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :with_sex_estimates, -> { where(sex_estimate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :with_total_estimates, -> { where(total_estimate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :most_recent, -> { ordered.first }

  def self.total_estimate_fields
    %i[e_pop_total m_pop_total]
  end

  def self.sex_estimate_fields
    %i[
      e_pop_male
      e_pop_female
      m_pop_male
      m_pop_female
    ]
  end

  # rubocop:disable Naming/VariableNumber
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
  # rubocop:enable Naming/VariableNumber

  def self.age_group_map
    [
      { label: "0-4",   key: "under_5" },
      { label: "5-9",   key: "5_9" },
      { label: "10-14", key: "10_14" },
      { label: "15-19", key: "15_19" },
      { label: "20-24", key: "20_24" },
      { label: "25-34", key: "25_34" },
      { label: "35-44", key: "35_44" },
      { label: "45-54", key: "45_54" },
      { label: "55-59", key: "55_59" },
      { label: "60-64", key: "60_64" },
      { label: "65-74", key: "65_74" },
      { label: "75-84", key: "75_84" },
      { label: "85+",   key: "85_plus" }
    ]
  end

  def self.sex_values_by_period
    reorder(end_year: :asc).map do |r|
      {
        period: "#{r.start_year}–#{r.end_year}",
        male_estimate: r.e_pop_male.to_i,
        male_moe: r.m_pop_male.to_i,
        female_estimate: r.e_pop_female.to_i,
        female_moe: r.m_pop_female.to_i
      }
    end
  end

  def self.age_values_by_period(year)
    record = find_by(end_year: year)

    return [] unless record

    age_group_map.map do |group|
      {
        label: group[:label],
        estimate: record["e_pop_age_#{group[:key]}"].to_i,
        moe: record["m_pop_age_#{group[:key]}"].to_i
      }
    end
  end

  def period_label
    "#{start_year}–#{end_year}"
  end
end
