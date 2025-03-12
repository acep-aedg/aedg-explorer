class Capacity < ApplicationRecord
  include CapacityAttributes
  belongs_to :grid, optional: true

  validates :grid_id, presence: true
end
