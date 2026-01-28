class ElectricRate < ApplicationRecord
  include ElectricRateAttributes

  validates :year, presence: true
  belongs_to :reporting_entity, optional: true
end
