class RegionalCorporation < ApplicationRecord
  has_many :communities, foreign_key: "regional_corporation_fips_code", primary_key: "fips_code"

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true

  default_scope { order(name: :asc )}
end
