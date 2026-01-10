class CommunitiesReportingEntity < ApplicationRecord
  include CommunitiesReportingEntityAttributes
  validates :community_fips_code, presence: true
  validates :reporting_entity_id, presence: true

  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :communities_reporting_entities
  belongs_to :reporting_entity, inverse_of: :communities_reporting_entities
end
