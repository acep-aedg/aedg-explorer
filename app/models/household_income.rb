class HouseholdIncome < ApplicationRecord
  include HouseholdIncomeAttributes
  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :household_incomes, optional: false, touch: true
end
