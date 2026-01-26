class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  # Scope to order by start year if needed
  scope :ordered, -> { order(start_year: :desc) }
end
