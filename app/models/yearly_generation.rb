class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes
  belongs_to :grid

  validates :grid_id,
            uniqueness: { scope: %i[year fuel_type],
                          message: 'combination of grid_id, year, and fuel type must be unique' }

  scope :grouped_net_generation_by_year, lambda {
    group(:year).sum(:net_generation_mwh)
  }
end
