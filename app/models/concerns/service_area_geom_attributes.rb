module ServiceAreaGeomAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      new.tap do |service_area_geom|
        service_area_geom.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aedg_id: params[:id],
        service_area_cpcn_id: params[:service_area_entity_id],
        boundary: params[:boundary]
      )
    end
  end
end
