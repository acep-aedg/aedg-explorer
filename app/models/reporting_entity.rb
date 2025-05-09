class ReportingEntity < ApplicationRecord
  include ReportingEntityAttributes
  include ImportFinders
  has_one :aedg_import, as: :importable, dependent: :destroy
  belongs_to :grid
  has_many :communities, dependent: :nullify
  has_many :electric_rates, dependent: :nullify

  validates :name, presence: true
  validates :grid, presence: true
  validates :year, presence: true
end
