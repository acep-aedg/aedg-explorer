# app/models/concerns/grid_attributes.rb
module GridAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!

      new.tap do |grid|
        grid.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        name: params[:name],
        aedg_import_attributes: { aedg_id: params[:id] }
      )
    end
  end
end
