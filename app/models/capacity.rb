class Capacity < ApplicationRecord
  include CapacityAttributes

  validates :aea_plant_id, presence: true

  belongs_to :plant, foreign_key: "aea_plant_id", primary_key: "aea_plant_id", inverse_of: :capacities

  scope :for_owner, ->(owner) { owner ? joins(:plant).merge(owner.plants) : all }
  scope :for_owner_and_year, ->(owner, year) { for_owner(owner).where(year: year) }

  def self.available_years_for(owner)
    for_owner(owner).where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.latest_year_for(owner)
    for_owner(owner).maximum(:year)
  end

  def self.capacity_stats_for(owner, year = nil)
    year ||= latest_year_for(owner)
    records   = for_owner_and_year(owner, year)
    min_rec   = records.order(:capacity_mw).first
    max_rec   = records.order(capacity_mw: :desc).first

    {
      total_capacity: records.sum(:capacity_mw).to_f.round(2),
      min_capacity: min_rec&.capacity_mw.to_f.round(2),
      min_fuel_type: min_rec&.fuel_type_code,
      max_capacity: max_rec&.capacity_mw.to_f.round(2),
      max_fuel_type: max_rec&.fuel_type_code,
      year: year
    }
  end

  def self.dataset_by_fuel_for(owner, year = nil)
    year ||= latest_year_for(owner)
    summed = for_owner_and_year(owner, year)
             .where.not(capacity_mw: nil)
             .group(:fuel_type_code, :fuel_type_name)
             .sum(:capacity_mw)

    dataset = summed.map do |(code, name), total|
      label = name.present? ? "#{name} (#{code})" : code
      [label, total]
    end

    dataset.sort_by { |label, _| label }
  end
end
