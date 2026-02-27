module SchoolDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      new.tap do |school|
        school.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        district: params[:id],
        name: params[:name],
        district_type: params[:type],
        is_active: params[:is_active],
        notes: params[:notes],
        boundary: params[:boundary]
      )
    end
  end
end
