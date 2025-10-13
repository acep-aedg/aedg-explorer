class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes
  validates :aea_plant_id, presence: true
  belongs_to :plant, foreign_key: 'aea_plant_id', primary_key: 'aea_plant_id', inverse_of: :yearly_generations

  validates :aea_plant_id,
            uniqueness: { scope: %i[year fuel_type_code],
                          message: 'combination of aea_plant_id, year, and fuel type_code must be unique' }

  def self.available_years
    where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  scope :for_grid_and_year, lambda { |grid, year|
    where(grid: grid, year: year)
  }
end
