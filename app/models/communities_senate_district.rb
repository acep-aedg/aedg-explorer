class CommunitiesSenateDistrict < ApplicationRecord
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :communities_senate_districts
  belongs_to :senate_district, foreign_key: :senate_district_district, primary_key: :district, inverse_of: :communities_senate_districts
end
