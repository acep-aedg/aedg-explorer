class YearlySale < ApplicationRecord
  include YearlySaleAttributes

  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity
  validates :year, presence: true
  validates :reporting_entity_id,
            uniqueness: { scope: %i[year],
                          message: "combination of reporting_entity_id & year" }
end
