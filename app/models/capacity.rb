class Capacity < ApplicationRecord
  include CapacityAttributes
  belongs_to :community, foreign_key: "grid_id", primary_key: "grid_id", optional: true

  validates :grid_id, presence: true
end
