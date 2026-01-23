class MonthlyGeneration < ApplicationRecord
  include MonthlyGenerationAttributes
  validates :aea_plant_id, presence: true
  belongs_to :plant, foreign_key: 'aea_plant_id', primary_key: 'aea_plant_id', inverse_of: :monthly_generations

  validates :aea_plant_id,
            uniqueness: { scope: %i[year month fuel_type_code source],
                          message: 'combination of aea_plant_id, year, month, fuel type_code, and source must be unique' }

  scope :for_owner,          ->(owner) { owner ? joins(:plant).merge(owner.plants) : all }
  scope :for_owner_and_year, ->(owner, year) { for_owner(owner).where(year: year) }

  scope :grouped_generation_by_year_month, -> { group(:year, :month).sum(:generation_mwh) }

  # --- Year helpers
  def self.available_years_for(owner)
    for_owner(owner).where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.latest_year_for(owner)
    for_owner(owner).maximum(:year)
  end

  # --- Stats used by a summary turbo-frame (min/max/avg, months, etc.)
  def self.generation_stats_for(owner, year = nil)
    year ||= latest_year_for(owner)
    records      = for_owner_and_year(owner, year)
    monthly_data = records.group(:month).sum(:generation_mwh) # {1=>..., 2=>...}

    values = monthly_data.values
    max_v  = values.max || 0
    min_v  = values.min || 0
    avg_v  = values.any? ? (values.sum.to_f / values.size).round(2) : 0.0

    {
      year: year,
      max_generation: max_v,
      min_generation: min_v,
      avg_generation: avg_v,
      max_month: monthly_data.key(max_v),
      min_month: monthly_data.key(min_v)
    }
  end

  def self.data_by_year(owner, year)
    grouped = for_owner_and_year(owner, year).group(:month).sum(:generation_mwh)

    (1..12).each_with_object({}) do |m, h|
      h[Date::ABBR_MONTHNAMES[m]] = grouped.fetch(m, 0)
    end
  end
end
