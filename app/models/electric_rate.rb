class ElectricRate < ApplicationRecord
  include ElectricRateAttributes

  validates :year, presence: true
  belongs_to :reporting_entity, optional: true

  scope :with_rates, -> { where(rate_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }

  def self.rate_fields
    %i[residential_rate commercial_rate industrial_rate]
  end
end
