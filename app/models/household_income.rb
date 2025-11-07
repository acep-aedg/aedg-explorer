class HouseholdIncome < ApplicationRecord
  include HouseholdIncomeAttributes
  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :household_incomes, optional: false

  HOUSEHOLD_INCOME_MAP = {
    # rubocop:disable Naming/VariableNumber
    e_household_inc_under_10000: 'Under $10,000',
    e_household_inc_10000_14999: '$10,000–$14,999',
    e_household_inc_15000_24999: '$15,000–$24,999',
    e_household_inc_25000_34999: '$25,000–$34,999',
    e_household_inc_35000_49999: '$35,000–$49,999',
    e_household_inc_50000_74999: '$50,000–$74,999',
    e_household_inc_75000_99999: '$75,000–$99,999',
    e_household_inc_100000_149999: '$100,000–$149,999',
    e_household_inc_150000_199999: '$150,000–$199,999',
    e_household_inc_200000_plus: '$200,000+'
    # rubocop:enable Naming/VariableNumber
  }.freeze

  def self.stacked_by_year(community)
    records = where(community: community).order(:end_year)
    HOUSEHOLD_INCOME_MAP.map do |col, label|
      {
        name: label,
        data: records.map do |r|
          year = r.end_year.to_i
          total = r.e_households_total.to_f.nonzero? || 1
          percent = ((r[col].to_f / total) * 100).round(2)
          [year, percent]
        end
      }
    end
  end
end
