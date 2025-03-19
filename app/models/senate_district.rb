class SenateDistrict < ApplicationRecord
  include SenateDistrictAttributes
  has_many :communities_legislative_districts, dependent: :destroy
  has_many :communities, through: :communities_legislative_districts
end
