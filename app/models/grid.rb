class Grid < ApplicationRecord
  include GridAttributes
  include ImportFinders
  has_one :aedg_import, as: :importable

  validates :name, presence: true, uniqueness: true
end
