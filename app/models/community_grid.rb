class CommunityGrid < ApplicationRecord
  include CommunityGridAttributes
  belongs_to :community, foreign_key: 'community_fips_code', primary_key: 'fips_code'
  belongs_to :grid
end
