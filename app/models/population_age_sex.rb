class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes
  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code"

  validates :community_fips_code, presence: true, uniqueness: { scope: [:start_year, :end_year, :geo_src], message: "community_fips_code, start_year, end_year and geo_src combination must be unique" }
end
