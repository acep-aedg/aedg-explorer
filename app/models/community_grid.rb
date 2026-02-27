class CommunityGrid < ApplicationRecord
  include CommunityGridAttributes

  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code", inverse_of: :community_grids
  belongs_to :grid

  scope :active, -> { where(termination_year: 9999) }
  scope :inactive, -> { where.not(termination_year: 9999) }
end
