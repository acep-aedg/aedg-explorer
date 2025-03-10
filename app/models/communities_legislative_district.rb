class CommunitiesLegislativeDistrict < ApplicationRecord
  include CommunitiesLegislativeDistrictAttributes

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code
  belongs_to :house_district, foreign_key: :house_district, primary_key: :house_district, optional: true
  belongs_to :senate_district, foreign_key: :senate_district, primary_key: :senate_district, optional: true

  validates :community_fips_code, presence: true
end
