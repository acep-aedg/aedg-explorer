class PopulationAgeSex < ApplicationRecord
  include PopulationAgeSexAttributes
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, touch: true

  # Scope to community records
  scope :for_community, ->(community) { where(community_fips_code: community.fips_code) }

  # Returns the most recent record for this community,
  # ensuring all fields in the required_group are NOT NULL (if provided).
  def self.most_recent_for(community, required_fields: nil)
    rel = for_community(community)

    Array(required_fields).each do |field|
      rel = rel.where.not(field => nil)
    end

    rel.order(end_year: :desc).first
  end

  # Scope to order by start year if needed
  scope :ordered, -> { order(start_year: :desc) }
end
