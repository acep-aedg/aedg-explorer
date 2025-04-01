class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes
  belongs_to :grid

  validates :grid_id, uniqueness: { scope: [:year, :fuel_type], message: "combination of grid_id, year, and fuel type must be unique" }

  scope :grouped_net_generation_by_year, -> {
    group(:year).sum(:net_generation_mwh)
  }
end
