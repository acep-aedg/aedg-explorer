class Capacity < ApplicationRecord
  include CapacityAttributes
  validates :aea_plant_id, presence: true
  belongs_to :plant, foreign_key: 'aea_plant_id', primary_key: 'aea_plant_id', inverse_of: :capacities

  scope :for_grid_and_year, lambda { |grid, year|
    where(grid: grid, year: year)
  }

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  def self.available_years
    where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.capacity_stats_for(grid, year = nil)
    year ||= latest_year_for(grid)
    records = for_grid_and_year(grid, year)
    min_record = records.order(:capacity_mw).first
    max_record = records.order(capacity_mw: :desc).first
    {
      total_capacity: records.sum(:capacity_mw).round(2),
      average_capacity: records.average(:capacity_mw)&.round(2),
      min_capacity: min_record&.capacity_mw&.round(2),
      min_fuel_type: min_record&.fuel_type_code,
      max_capacity: max_record&.capacity_mw&.round(2),
      max_fuel_type: max_record&.fuel_type_code,
      year: year
    }
  end
end
