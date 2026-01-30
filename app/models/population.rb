class Population < ApplicationRecord
  include PopulationAttributes

  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code"

  validates :community_fips_code, presence: true, uniqueness: true
  validates :total_population, presence: true
end
