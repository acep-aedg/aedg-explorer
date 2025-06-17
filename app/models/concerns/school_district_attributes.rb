module SchoolDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      properties['boundary'] = geom
      properties.symbolize_keys!

      SchoolDistrict.new.tap do |school|
        school.assign_aedg_attributes(properties)
        school.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aedg_id: params[:id],
        name: params[:name],
        district_type: params[:type],
        is_active: params[:is_active],
        boundary: params[:boundary]
      )
    end
  end
end
