# This is not a join table.
# CommunitiesLegislativeDistrict is a reference model that maps a community to its
# legislative districts (house, senate, election region).
# It references shared district data but stores its own mapping context.
# Associations to house_district and senate_district are optional and should not be deleted with this model.

class CommunitiesLegislativeDistrict < ApplicationRecord
  include CommunitiesLegislativeDistrictAttributes
  belongs_to :community,
             foreign_key: :community_fips_code,
             primary_key: :fips_code

  belongs_to :house_district,
             foreign_key: :house_district,
             primary_key: :house_district,
             optional: true

  validates :community_fips_code, presence: true
end
