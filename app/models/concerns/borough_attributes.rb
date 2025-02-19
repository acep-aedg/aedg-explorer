# app/models/concerns/borough_attributes.rb
module BoroughAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties, geo_object)
      assign_attributes(
        name: properties['name'],
        is_census_area: properties['is_census_area'],
        boundary: geo_object
      )
    end
  end
end