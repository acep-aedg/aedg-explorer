class YearlyElectricRate < ApplicationRecord
  include YearlyElectricRateAttributes

  validates :year, presence: true
  belongs_to :reporting_entity

  scope :with_rates, -> { where(rate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }

  def self.rate_fields
    %i[residential_rate residential_rate_subsidized commercial_rate industrial_rate transportation_rate community_rate other_rate total_rate]
  end

  def self.active_fields
    rate_fields.select { |field| where.not(field => nil).exists? }
  end
end
