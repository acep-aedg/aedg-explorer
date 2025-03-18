class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  has_many :communities_legislative_districts, dependent: :destroy
  has_many :communities, through: :communities_legislative_districts
end
