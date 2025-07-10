class CommunitiesSchoolDistrict < ApplicationRecord
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :communities_school_districts
  belongs_to :school_district, foreign_key: :school_district_district, primary_key: :district, inverse_of: :communities_school_districts
end
