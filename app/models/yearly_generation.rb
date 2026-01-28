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

  def self.yearly_series_by_energy_source(owner)
    raw_data = owner.yearly_generations
                    .group(:fuel_type_code, :fuel_type_name, :year)
                    .sum(:generation_mwh)

    years_present = raw_data.keys.map(&:last)
    return [] if years_present.empty?

    all_years = (years_present.min..years_present.max).to_a
    unique_sources = raw_data.keys.pluck(0..1).uniq

    series_list = unique_sources.map do |code, name|
      padded_data = all_years.each_with_object({}) do |year, hash|
        # Use nil for missing years to create ensure chronological order
        value = raw_data[[code, name, year]]
        hash[year.to_s] = value&.zero? ? nil : value
      end

      {
        name: "#{name} (#{code})",
        code: code,
        data: padded_data
      }
    end

    series_list.reject! { |s| s[:data].values.compact.empty? }
    series_list.sort_by { |s| s[:data].values.compact.sum }
  end
end
