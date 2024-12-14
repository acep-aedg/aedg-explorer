class Community < ApplicationRecord
  include CommunityAttributes
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Handle the case where the name is not unique
  def slug_candidates
    [
      :name,
      [:name, :fips_code]
    ]
  end

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :ansi_code, presence: true, uniqueness: true
  validates :community_id, presence: true, uniqueness: true
  validates :global_id, presence: true, uniqueness: true
end
