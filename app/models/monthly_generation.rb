class MonthlyGeneration < ApplicationRecord
  include MonthlyGenerationAttributes

  validates :aea_plant_id, presence: true
  validates :month, presence: true
  belongs_to :plant, foreign_key: "aea_plant_id", primary_key: "aea_plant_id", inverse_of: :monthly_generations

  validates :aea_plant_id,
            uniqueness: { scope: %i[year month fuel_type_code source],
                          message: "combination of aea_plant_id, year, month, fuel type_code, and source must be unique" }

  def self.available_years
    where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.total_mwh_by_year(year)
    records = where(year: year.to_i)

    grouped = records.each_with_object(Hash.new(0)) do |r, hash|
      hash[r.month] += r.generation_mwh
    end

    (1..12).to_h do |m|
      [Date::ABBR_MONTHNAMES[m], grouped[m]]
    end
  end
end
