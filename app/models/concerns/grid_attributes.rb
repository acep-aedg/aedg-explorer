# app/models/concerns/grid_attributes.rb
module GridAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      if properties[:id].nil?
        raise "id is required"
      end

      Grid.create!(
        name: properties[:name], 
        aedg_id: properties[:id]
      )
    end
  end
end