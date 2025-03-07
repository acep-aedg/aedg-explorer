class Employment < ApplicationRecord
  include EmploymentAttributes
  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code"

  validates :community_fips_code, presence: true
end
