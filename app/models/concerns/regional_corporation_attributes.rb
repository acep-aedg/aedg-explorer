# app/models/concerns/regional_corporation_attributes.rb
module RegionalCorporationAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      new.tap do |reg_corp|
        reg_corp.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        fips_code: params[:fips_code],
        name: params[:name],
        land_area: params[:land_area],
        water_area: params[:water_area],
        boundary: params[:boundary]
      )
    end
  end
end
