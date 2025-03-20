class Capacity < ApplicationRecord
  include CapacityAttributes
  belongs_to :grid, optional: true
  validates :grid_id, presence: true

  def self.latest_year
    maximum(:year)
  end

  def self.capacity_stats
    min_record = order(:capacity_mw).first
    max_record = order(capacity_mw: :desc).first

    {
      total_capacity: sum(:capacity_mw).round(2),
      average_capacity: average(:capacity_mw).round(2),
      min_capacity: min_record&.capacity_mw&.round(2),
      min_fuel_type: min_record&.fuel_type,
      max_capacity: max_record&.capacity_mw&.round(2),
      max_fuel_type: max_record&.fuel_type,
      year: latest_year
    }
  end
end
