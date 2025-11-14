class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  # Scope to community records
  scope :for_community, ->(community) { where(community_fips_code: community.fips_code) }

  # Class method that returns *one* record: the one with the highest end_year
  def self.most_recent_for(community)
    rel = for_community(community)
    max_year = rel.maximum(:end_year)
    return nil unless max_year

    rel.find_by(end_year: max_year)
  end

  # Scope to filter by gender
  scope :by_gender, ->(gender) { where(gender: gender) }

  # Scope to order by start year if needed
  scope :ordered, -> { order(start_year: :desc) }
end
