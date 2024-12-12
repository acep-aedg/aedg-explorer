class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :ansi_code, presence: true, uniqueness: true
  validates :community_id, presence: true, uniqueness: true
  validates :global_id, presence: true, uniqueness: true
end
