# app/models/concerns/grid_attributes.rb
module GridAttributes
  extend ActiveSupport::Concern

  included do
    def self.import_aedg_attributes(properties)
      properties.symbolize_keys!

      existing_grid = Grid.find_by(name: properties[:name])
      existing_import = AedgImport.find_by(aedg_id: properties[:id], importable_type: "Grid")

      # Skip if either a grid with this name exists
      if existing_grid
        return existing_grid
      end

      g = Grid.build(
        name: properties[:name]
      )
      g
    end
  end
end