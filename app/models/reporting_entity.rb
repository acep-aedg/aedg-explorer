class ReportingEntity < ApplicationRecord
  include ReportingEntityAttributes
  include ImportFinders
  has_one :aedg_import, as: :importable, dependent: :destroy
  belongs_to :grid, touch: true
  has_many :communities, dependent: :nullify
  has_many :electric_rates, dependent: :nullify
  has_many :sales, dependent: :nullify

  validates :name, presence: true
  validates :grid, presence: true

  def latest_sale
    sales.order(year: :desc).first
  end
end
