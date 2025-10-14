class MonthlyGeneration < ApplicationRecord
  include MonthlyGenerationAttributes
  validates :aea_plant_id, presence: true
  belongs_to :plant, foreign_key: 'aea_plant_id', primary_key: 'aea_plant_id', inverse_of: :monthly_generations

  validates :aea_plant_id,
            uniqueness: { scope: %i[year month fuel_type_code],
                          message: 'combination of aea_plant_id, year, month and fuel type_code must be unique' }

  scope :grouped_net_generation_by_year_month, lambda {
    group(:year, :month).sum(:net_generation_mwh)
  }

  scope :for_grid_and_year, lambda { |grid, year|
    where(grid: grid, year: year)
  }

  def self.available_years
    where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  def self.generation_stats_for(grid, year = nil)
    year ||= latest_year_for(grid)
    records = for_grid_and_year(grid, year)
    monthly_data = records.group(:month).sum(:net_generation_mwh)

    max_generation = monthly_data.values.max || 0
    min_generation = monthly_data.values.min || 0
    avg_generation = ((monthly_data.values.sum.to_f / monthly_data.size).round(2) if monthly_data.any?)

    {
      max_generation: max_generation,
      min_generation: min_generation,
      avg_generation: avg_generation,
      max_month: monthly_data.key(max_generation),
      min_month: monthly_data.key(min_generation),
      year: year
    }
  end
end
