module CommunitiesServiceAreaGeomAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      raise 'Skipped: missing service_area_geom_id' if properties[:service_area_geom_id].blank?

      CommunitiesServiceAreaGeom.new.tap do |service_area_geom|
        service_area_geom.assign_aedg_attributes(properties)
        service_area_geom.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        service_area_geom_aedg_id: params[:service_area_geom_id]
      )
    end
  end
end
