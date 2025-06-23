class Grid < ApplicationRecord
  include GridAttributes
  include ImportFinders
  has_one :aedg_import, as: :importable
  has_many :community_grids
  has_many :communities, through: :community_grids
  has_many :yearly_generations
  has_many :monthly_generations
  has_many :capacities
  has_many :reporting_entities
  validates :name, presence: true, uniqueness: true

  def utility_names(exclude: nil)
    query = reporting_entities
    query = query.where.not(name: exclude) if exclude.present?
    query.distinct.pluck(:name)
  end
end
