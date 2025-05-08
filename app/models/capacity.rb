class Capacity < ApplicationRecord
  include CapacityAttributes
  belongs_to :grid
  validates :grid_id, presence: true

  def self.latest_year_for(grid)
    where(grid: grid).maximum(:year)
  end

  scope :grouped_capacity_by_fuel_type, lambda {
    group(:fuel_type).sum(:capacity_mw)
  }

  def self.capacity_stats_for(grid)
    scoped = where(grid: grid)
    year = scoped.maximum(:year)
    return {} unless year

    latest_year_records = scoped.where(year: year)
    min_record = latest_year_records.order(:capacity_mw).first
    max_record = latest_year_records.order(capacity_mw: :desc).first

    {
      total_capacity: latest_year_records.sum(:capacity_mw).round(2),
      average_capacity: latest_year_records.average(:capacity_mw)&.round(2),
      min_capacity: min_record&.capacity_mw&.round(2),
      min_fuel_type: min_record&.fuel_type,
      max_capacity: max_record&.capacity_mw&.round(2),
      max_fuel_type: max_record&.fuel_type,
      year: year
    }
  end
end
