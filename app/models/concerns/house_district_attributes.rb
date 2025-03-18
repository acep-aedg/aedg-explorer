module HouseDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      # pp properties
      properties.symbolize_keys!

      HouseDistrict.new.tap do |house|
        house.assign_aedg_attributes(properties)
        house.boundary = geom
        house.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        district: params[:district],
        name: params[:name],
        as_of_date: params[:as_of_date],
        boundary: params[:boundary]
      )
    end
  end
end
