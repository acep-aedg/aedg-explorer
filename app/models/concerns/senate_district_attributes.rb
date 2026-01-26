module SenateDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      SenateDistrict.new.tap do |senate|
        senate.assign_aedg_attributes(properties)
        senate.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        district: params[:district],
        as_of_date: params[:as_of_date],
        boundary: params[:boundary]
      )
    end
  end
end
