# app/models/concerns/regional_corporation_attributes.rb
module RegionalCorporationAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties, geo_object)
      assign_attributes(
        name: properties['name'],
        boundary: geo_object
      )
    end
  end
end