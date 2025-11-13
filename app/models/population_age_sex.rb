class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  # Scope to get most recent population detail data for a community, treating geo_src: 'P' as source of truth until sorted out
  scope :most_recent_for, ->(community_id) { where(community_fips_code: community_id).where(is_most_recent: true).where(geo_src: 'P') }

  # Scope to filter by gender
  scope :by_gender, ->(gender) { where(gender: gender) }

  # Scope to order by start year if needed
  scope :ordered, -> { order(start_year: :desc) }
end
