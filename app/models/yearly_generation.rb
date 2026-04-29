class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes

  validates :aea_plant_id, presence: true
  validates :aea_plant_id, uniqueness: { scope: %i[year fuel_type_code], message: "combination of aea_plant_id, year, and fuel type_code must be unique" }

  belongs_to :plant, foreign_key: "aea_plant_id", primary_key: "aea_plant_id", inverse_of: :yearly_generations

  def self.total_mwh_by_energy_source
    # Preserve distinct by converting to array first
    records = all.to_a
    return [] if records.empty?

    raw_data = records.group_by { |r| [r.fuel_type_code, r.fuel_type_name, r.year] }
    years = records.map(&:year).compact.uniq.sort
    all_years = (years.min..years.max).to_a
    unique_sources = records.map { |r| [r.fuel_type_code, r.fuel_type_name] }.uniq

    series_list = unique_sources.map do |code, name|
      build_series_item(code, name, all_years, raw_data)
    end

    series_list.reject { |s| s[:data].values.compact.empty? }
               .sort_by { |s| s[:data].values.compact.sum }
  end

  def self.build_series_item(code, name, all_years, raw_data)
    timeline_data = all_years.each_with_object({}) do |year, hash|
      matches = raw_data[[code, name, year]] || []
      value = matches.sum { |r| r.generation_mwh.to_f }

      hash[year.to_s] = value.zero? ? nil : value
    end

    {
      name: name.present? ? "#{name} (#{code})" : code,
      code: code,
      data: timeline_data
    }
  end
end
