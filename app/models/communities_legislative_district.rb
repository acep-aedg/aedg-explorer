class CommunitiesLegislativeDistrict < ApplicationRecord
  include CommunitiesLegislativeDistrictAttributes
  belongs_to :community
  belongs_to :house_district
  belongs_to :senate_district
end
