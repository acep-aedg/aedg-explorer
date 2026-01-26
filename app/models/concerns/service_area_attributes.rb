module ServiceAreaAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      ServiceArea.new.tap do |service_area|
        service_area.assign_aedg_attributes(properties)
        service_area.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        cpcn_id: params[:cpcn_id],
        name: params[:service_area_name],
        certificate_url: params[:url],
        boundary: params[:boundary]
      )
    end
  end
end
