# app/models/concerns/borough_attributes.rb
module BoroughAttributes
  extend ActiveSupport::Concern

  class_methods do 
    def import_aedg_with_geom!(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      Borough.find_or_initialize_by(fips_code: properties[:fips_code]).tap do |borough|
        borough.assign_aedg_attributes(properties)
        borough.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes({
        fips_code: params[:fips_code],
        name: params[:name],
        boundary: params[:boundary]
      })
    end
  end
end
