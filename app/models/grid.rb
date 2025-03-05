class Grid < ApplicationRecord
  include GridAttributes
  include ImportFinders
  has_one :aedg_import, as: :importable
  has_many :communities
  has_many :yearly_generations

  validates :name, presence: true, uniqueness: true
end
