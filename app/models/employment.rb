class Employment < ApplicationRecord
  include EmploymentAttributes

  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code", touch: true

  validates :community_fips_code, presence: true, uniqueness: { scope: :measurement_year }
end
