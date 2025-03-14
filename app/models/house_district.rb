class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  has_many :communities_legislative_districts,
           foreign_key: :house_district,
           primary_key: :house_district,
           dependent: :destroy

  has_many :communities,
           through: :communities_legislative_districts,
           source: :community
end
