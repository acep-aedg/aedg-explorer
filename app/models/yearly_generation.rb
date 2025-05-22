class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes
  belongs_to :grid

  validates :grid_id,
            uniqueness: { scope: %i[year fuel_type_code],
                          message: 'combination of grid_id, year, and fuel type_code must be unique' }

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  scope :for_grid_and_year, lambda { |grid, year|
    where(grid: grid, year: year)
  }
end
