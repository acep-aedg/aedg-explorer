class MonthlyGeneration < ApplicationRecord
  include MonthlyGenerationAttributes
  belongs_to :grid

  validates :grid_id,
            uniqueness: { scope: %i[year fuel_type_code month],
                          message: 'combination of grid_id, year, month, and fuel_type_code must be unique' }

  scope :grouped_net_generation_by_year_month, lambda {
    group(:year, :month).sum(:net_generation_mwh)
  }

  scope :sum_net_generation_by_month, lambda { |year|
    where(year: year).group(:month).sum(:net_generation_mwh)
  }

  def self.latest_year
    maximum(:year)
  end

  def self.generation_stats(year = latest_year)
    monthly_data = sum_net_generation_by_month(year)
    max_generation = monthly_data.values.max || 0
    min_generation = monthly_data.values.min || 0
    avg_generation = (monthly_data.values.sum.to_f / monthly_data.size).round(2) if monthly_data.any?

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
