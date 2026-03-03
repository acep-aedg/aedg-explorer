module ServiceAreaAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      new.tap do |service_area|
        service_area.assign_aedg_attributes(properties)
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
