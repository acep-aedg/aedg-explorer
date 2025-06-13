class CommunitiesSenateDistrict < ApplicationRecord
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code
  belongs_to :senate_district, foreign_key: :senate_district_district, primary_key: :district
end
