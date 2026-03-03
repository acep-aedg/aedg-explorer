module HouseDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      new.tap do |house|
        house.assign_aedg_attributes(properties)
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
