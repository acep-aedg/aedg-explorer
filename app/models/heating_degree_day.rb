class HeatingDegreeDay < ApplicationRecord
  include HeatingDegreeDayAttributes
  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :heating_degree_days, optional: false, touch: true
end
