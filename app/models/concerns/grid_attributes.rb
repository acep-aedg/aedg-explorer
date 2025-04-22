# app/models/concerns/grid_attributes.rb
module GridAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      raise 'id is required' if properties[:id].nil?

      Grid.create!(
        name: properties[:name],
        aedg_id: properties[:id]
      )
    end
  end
end
