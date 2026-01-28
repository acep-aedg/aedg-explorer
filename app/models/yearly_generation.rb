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

  def self.dataset_by_fuel_for(owner, year = nil)
    year ||= latest_year_for(owner)
    summed = for_owner_and_year(owner, year)
             .where.not(generation_mwh: nil)
             .group(:fuel_type_code, :fuel_type_name)
             .sum(:generation_mwh)

    dataset = summed.map do |(code, name), total|
      label = name.present? ? "#{name} (#{code})" : code
      [label, total]
    end

    dataset.sort_by { |label, _| label }
  end

  def self.series_by_energy_source(owner)
    raw_data = owner.yearly_generations
                    .group(:fuel_type_code, :fuel_type_name, :year)
                    .sum(:generation_mwh)

    return [] if raw_data.empty?

    all_years = (raw_data.keys.map(&:last).min..raw_data.keys.map(&:last).max).to_a
    unique_sources = raw_data.keys.pluck(0..1).uniq

    series_list = unique_sources.map do |code, name|
      build_series_item(code, name, all_years, raw_data)
    end

    # Filter out series with no non-zero data and sort by total volume
    series_list.reject { |s| s[:data].values.compact.empty? }
               .sort_by { |s| s[:data].values.compact.sum }
  end

  def self.build_series_item(code, name, all_years, raw_data)
    timeline_data = all_years.each_with_object({}) do |year, hash|
      value = raw_data[[code, name, year]]
      # Treat 0 or 0.0 as nil to create "holes" in the chart
      hash[year.to_s] = value&.zero? ? nil : value
    end

    {
      name: "#{name} (#{code})",
      code: code,
      data: timeline_data
    }
  end
end
