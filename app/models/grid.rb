class Grid < ApplicationRecord
  include GridAttributes
  include ImportFinders
  has_one :aedg_import, as: :importable
  has_many :community_grids
  has_many :communities, through: :community_grids
  has_many :yearly_generations
  has_many :monthly_generations
  has_many :capacities
  validates :name, presence: true, uniqueness: true
end
