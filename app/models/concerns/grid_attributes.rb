# app/models/concerns/grid_attributes.rb
module GridAttributes
  extend ActiveSupport::Concern

  included do
    def self.import_aedg_attributes(properties)
      properties.symbolize_keys!

      g = Grid.build(
        name: properties[:name],
        aedg_id: properties[:id]
      )
      g
    end
  end
end