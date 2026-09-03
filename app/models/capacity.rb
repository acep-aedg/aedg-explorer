class Capacity < ApplicationRecord
  include CapacityAttributes

  validates :aea_plant_id, presence: true

  belongs_to :plant, foreign_key: "aea_plant_id", primary_key: "aea_plant_id", inverse_of: :capacities

  def self.available_years
    distinct.where.not(year: nil).order(year: :desc).pluck(:year)
  end

  def self.total_mw_by_fuel(target_year)
    records = where(year: target_year).to_a
    grouped = records.group_by { |r| [r.fuel_type_code, r.fuel_type_name] }

    dataset = grouped.map do |(code, name), group_records|
      label = name.present? ? "#{name} (#{code})" : code
      total = group_records.sum { |r| r.capacity_mw.to_f }
      [label, total]
    end

    dataset.sort_by { |label, _| label }
  end
end
