class YearlyGeneration < ApplicationRecord
  include YearlyGenerationAttributes
  validates :aea_plant_id, presence: true
  validates :aea_plant_id, uniqueness: { scope: %i[year fuel_type_code], message: 'combination of aea_plant_id, year, and fuel type_code must be unique' }

  belongs_to :plant, foreign_key: 'aea_plant_id', primary_key: 'aea_plant_id', inverse_of: :yearly_generations

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
             .where.not(net_generation_mwh: nil)
             .group(:fuel_type_code, :fuel_type_name)
             .sum(:net_generation_mwh)

    dataset = summed.map do |(code, name), total|
      label = name.present? ? "#{name} (#{code})" : code
      [label, total]
    end

    dataset.sort_by { |label, _| label }
  end
end
