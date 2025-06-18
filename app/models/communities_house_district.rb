class CommunitiesHouseDistrict < ApplicationRecord
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :communities_house_districts
  belongs_to :house_district, foreign_key: :house_district_district, primary_key: :district, inverse_of: :communities_house_districts
end
