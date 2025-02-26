class Community < ApplicationRecord
  include CommunityAttributes
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :borough, foreign_key: "borough_fips_code", primary_key: "fips_code"
  belongs_to :regional_corporation, foreign_key: "regional_corporation_fips_code", primary_key: "fips_code", optional: true
  has_one :population, foreign_key: "community_fips_code", primary_key: "fips_code"
  has_one :transportation, foreign_key: "community_fips_code", primary_key: "fips_code"

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
  validates :borough_fips_code, presence: true
  validates :dcra_code, presence: true, uniqueness: true

  default_scope { order(name: :asc )}

end
