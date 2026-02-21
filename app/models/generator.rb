class Generator < ApplicationRecord
  include GeneratorAttributes

  belongs_to :plant, foreign_key: :aea_plant_id, primary_key: :aea_plant_id, inverse_of: :generators
end
