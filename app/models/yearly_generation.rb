class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes

  validates :aea_plant_id, presence: true
  validates :aea_plant_id, uniqueness: { scope: %i[year fuel_type_code], message: "combination of aea_plant_id, year, and fuel type_code must be unique" }

  belongs_to :plant, foreign_key: "aea_plant_id", primary_key: "aea_plant_id", inverse_of: :yearly_generations

  scope :for_owner, ->(owner) { owner ? joins(:plant).merge(owner.plants) : all }
  scope :for_owner_and_year, ->(owner, year) { for_owner(owner).where(year: year) }

  def self.available_years_for(owner)
    for_owner(owner).where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.latest_year_for(owner)
    for_owner(owner).maximum(:year)
  end

  def self.yearly_series_by_energy_source(owner)
    raw_data = owner.yearly_generations
                    .group(:fuel_type_code, :fuel_type_name, :year)
                    .sum(:generation_mwh)

    grouped = raw_data.each_with_object({}) do |((code, name, year), amount), result|
      next if amount.zero?

      result[code] ||= { name: name, data: {} }
      result[code][:data][year] = amount
    end

    series_list = grouped.map do |code, info|
      {
        name: "#{info[:name]} (#{code})",
        code: code,
        data: info[:data].sort.to_h
      }
    end

    series_list.sort_by { |series| series[:data].values.sum }
  end
end
