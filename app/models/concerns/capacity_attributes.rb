module CapacityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      Capacity.new.tap do |capacity|
        capacity.assign_aedg_attributes(properties)
        capacity.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        grid: Grid.from_aedg_id(params[:grid_id]).first,
        capacity_mw: params[:capacity_mw],
        fuel_type: params[:fuel_type],
        year: params[:year]
      )
    end
  end
end
