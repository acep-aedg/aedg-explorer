class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes
  belongs_to :grid

  validates :grid_id,
            uniqueness: { scope: %i[year fuel_type],
                          message: 'combination of grid_id, year, and fuel type must be unique' }

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  scope :grouped_net_generation_by_fuel_type, lambda {
    group(:fuel_type).sum(:net_generation_mwh)
  }
end
