class Community < ApplicationRecord
  include CommunityAttributes
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :borough, foreign_key: "borough_fips_code", primary_key: "fips_code"
  belongs_to :regional_corporation, foreign_key: "regional_corporation_fips_code", primary_key: "fips_code", optional: true
  has_one :population, foreign_key: "community_fips_code", primary_key: "fips_code"
  has_one :transportation, foreign_key: "community_fips_code", primary_key: "fips_code"
  belongs_to :grid, optional: true

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
  validates :location, presence: true, allowed_geometry_types: ["Point"]

  default_scope { order(name: :asc )}

    # Fetch total community count
    def self.total_count
      count
    end

    # Fetch communities grouped by PCE eligibility
    def self.pce_eligibility_count
      {
        pce_eligible: where(pce_eligible: true).count,
        not_eligible: where(pce_eligible: false).count
      }
    end

    # Get data for Bubble Chart (longitude, latitude, name, size)
    def self.bubble_chart_data
      where.not(latitude: nil, longitude: nil).map do |community|
        {
          name: community.name,
          x: community.longitude.to_f,
          y: community.latitude.to_f,
          pce_eligible: community.pce_eligible  # Send boolean to JS
        }
      end
    end
end
