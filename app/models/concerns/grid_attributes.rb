# app/models/concerns/grid_attributes.rb
module GridAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      if properties[:id].nil?
        raise "id is required"
      end

      g = Grid.build(
        name: properties[:name],
        aedg_id: properties[:id]
      )
      g.save!
    end
  end
end