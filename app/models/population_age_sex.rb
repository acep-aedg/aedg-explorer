class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes
  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code"

end
