class MonthlySale < ApplicationRecord
  include MonthlySaleAttributes

  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity
  validates :year, :month, presence: true
  validates :reporting_entity_id,
            uniqueness: { scope: %i[year month],
                          message: "combination of reporting_entity_id, year & month" }
end
