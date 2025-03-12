class MonthlyGeneration < ApplicationRecord
  include MonthlyGenerationAttributes
  belongs_to :grid

  validates :grid_id, uniqueness: { scope: [:year, :fuel_type, :month], message: "combination of grid_id, year, month, and fuel type must be unique" }
end
