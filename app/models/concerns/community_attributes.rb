# app/models/concerns/community_attributes.rb
module CommunityAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties, geo_object)
      assign_attributes(
        name: properties['name'],
        regional_corporation_fips_code: properties['regional_corporation_fips_code'],
        borough_fips_code: properties['borough_fips_code'],
        grid: Grid.from_aedg_id(properties['grid_id']).first,
        ansi_code: properties['ansi_code'],
        dcra_code: properties['dcra_code'],
        pce_eligible: properties['pce_eligible'],
        pce_active: properties['pce_active'],
        latitude: properties['latitude'],
        longitude: properties['longitude'],
        location: geo_object
      )
    end
  end
end