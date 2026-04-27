class Grid < ApplicationRecord
  include GridAttributes
  include Facetable
  include ImportFinders
  include Displayable
  include Searchable
  extend FriendlyId

  accepts_nested_attributes_for :aedg_import
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: true
  has_one :aedg_import, as: :importable
  has_many :community_grids
  has_many :communities, through: :community_grids
  has_many :reporting_entities
  has_many :plants
  has_many :service_area_geoms, -> { distinct }, through: :plants
  has_many :service_areas, -> { distinct }, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  default_scope { order(name: :asc) }
  scope :active, -> { where(id: CommunityGrid.active.select(:grid_id)) }

  def to_s
    name
  end

  def utility_names(exclude: nil)
    query = reporting_entities
    query = query.where.not(name: exclude) if exclude.present?
    query.distinct.pluck(:name)
  end
end
