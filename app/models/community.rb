class Community < ApplicationRecord
  include CommunityAttributes
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :borough, foreign_key: 'borough_fips_code', primary_key: 'fips_code'
  belongs_to :regional_corporation, foreign_key: 'regional_corporation_fips_code', primary_key: 'fips_code',
                                    optional: true

  has_many :employments, foreign_key: 'community_fips_code', primary_key: 'fips_code'
  has_one :transportation, foreign_key: 'community_fips_code', primary_key: 'fips_code'
  has_one :population, foreign_key: 'community_fips_code', primary_key: 'fips_code'
  has_many :population_age_sexes, foreign_key: 'community_fips_code', primary_key: 'fips_code'

  has_many :communities_legislative_districts, foreign_key: 'community_fips_code', primary_key: 'fips_code'
  has_many :house_districts, through: :communities_legislative_districts
  has_many :senate_districts, through: :communities_legislative_districts

  has_many :community_grids, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  has_many :grids, through: :community_grids
  has_many :capacities, through: :grids
  has_many :monthly_generations, through: :grids
  has_many :yearly_generations, through: :grids
  has_many :fuel_prices, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :community
  belongs_to :reporting_entity, optional: true
  has_many :electric_rates, through: :reporting_entity

  # Handle the case where the name is not unique
  def slug_candidates
    [
      :name,
      %i[name fips_code]
    ]
  end

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :borough_fips_code, presence: true
  validates :location, presence: true, allowed_geometry_types: ['Point']

  default_scope { order(name: :asc) }

  def election_regions
    communities_legislative_districts.pluck(:election_region).uniq
  end

  def grid
    community_grids.find_by(termination_year: 9999)&.grid
  end
end
