# app/models/concerns/borough_attributes.rb
module BoroughAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg_geojson(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      new.tap do |borough|
        borough.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes({
                          fips_code: params[:fips_code],
                          name: params[:name],
                          boundary: params[:boundary],
                          is_census_area: params[:is_census_area]
                        })
    end
  end
end
