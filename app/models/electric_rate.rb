class ElectricRate < ApplicationRecord
  include ElectricRateAttributes
  belongs_to :reporting_entity, optional: true

  scope :most_recent, -> { order(year: :desc).limit(1) }

  validates :year, presence: true
end
