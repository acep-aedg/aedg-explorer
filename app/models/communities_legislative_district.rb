class CommunitiesLegislativeDistrict < ApplicationRecord
  include CommunitiesLegislativeDistrictAttributes
  belongs_to :community, foreign_key: 'community_fips_code', primary_key: 'fips_code'
  belongs_to :house_district, dependent: :destroy
  belongs_to :senate_district, dependent: :destroy
end
