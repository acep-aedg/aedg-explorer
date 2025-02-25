class Population < ApplicationRecord
  belongs_to :community, foreign_key: "fips_code", primary_key: "fips_code"

  validates :fips_code, presence: true, uniqueness: true
  validates :total_population, presence: true
end
