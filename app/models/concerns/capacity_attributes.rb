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
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        capacity_mw: params[:nameplate_capacity_mw],
        fuel_type_code: params[:fuel_type_code],
        fuel_type_name: params[:fuel_type_name],
        year: params[:year]
      )
    end
  end
end
