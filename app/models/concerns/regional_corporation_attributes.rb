# app/models/concerns/regional_corporation_attributes.rb
module RegionalCorporationAttributes
  extend ActiveSupport::Concern

   class_methods do 
    def import_aedg_with_geom!(properties, geom)
      properties["boundary"] = geom
      properties.symbolize_keys!

      RegionalCorporation.find_or_initialize_by(fips_code: properties[:fips_code]).tap do |reg_corp|
        reg_corp.assign_aedg_attributes(properties)
        reg_corp.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        fips_code: params[:fips_code],
        name: params[:name],
        boundary: params[:boundary],
      )
    end
  end
end