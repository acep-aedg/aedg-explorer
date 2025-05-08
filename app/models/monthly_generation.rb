class MonthlyGeneration < ApplicationRecord
  include MonthlyGenerationAttributes
  belongs_to :grid

  validates :grid_id,
            uniqueness: { scope: %i[year fuel_type month],
                          message: 'combination of grid_id, year, month, and fuel type must be unique' }

  scope :grouped_net_generation_by_year_month, lambda {
    group(:year, :month).sum(:net_generation_mwh)
  }

  scope :sum_net_generation_by_month, lambda { |year|
    where(year: year).group(:month).sum(:net_generation_mwh)
  }

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  def self.generation_stats_for(grid)
    scoped = where(grid: grid)
    year = scoped.maximum(:year)
    return {} unless year

    latest_year_records = scoped.where(year: year)
    monthly_data = latest_year_records.group(:month).sum(:net_generation_mwh)

    max_generation = monthly_data.values.max || 0
    min_generation = monthly_data.values.min || 0
    avg_generation = if monthly_data.any?
      (monthly_data.values.sum.to_f / monthly_data.size).round(2)
    end

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
