class Grid < ApplicationRecord
  include GridAttributes
  include Facetable
  include ImportFinders
  include Displayable
  extend FriendlyId

  accepts_nested_attributes_for :aedg_import
  friendly_id :slug_candidates, use: :slugged
  validates :name, presence: true, uniqueness: true
  has_one :aedg_import, as: :importable
  has_many :community_grids
  has_many :communities, through: :community_grids
  has_many :reporting_entities
  has_many :plants
  has_many :service_area_geoms, through: :plants
  has_many :service_areas, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  default_scope { order(name: :asc) }
  scope :active, -> { joins(:community_grids).merge(CommunityGrid.active).distinct }
  scope :starts_with, ->(letter) { where("name ILIKE ?", "#{letter}%") if letter.present? }

  def slug_candidates
    [
      :name
    ]
  end

  def self.search_related(query)
    where("name ILIKE ?", "%#{query}%")
  end

  def utility_names(exclude: nil)
    query = reporting_entities
    query = query.where.not(name: exclude) if exclude.present?
    query.distinct.pluck(:name)
  end

  def pce_eligible_communities?
    return @pce_eligible_communities if defined?(@pce_eligible_communities)

    @pce_eligible_communities = communities.exists?(pce_eligible: true)
  end
end
