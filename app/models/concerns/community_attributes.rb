# app/models/concerns/community_attributes.rb
module CommunityAttributes
  extend ActiveSupport::Concern

  included do
    def self.import_aedg_attributes(properties)
      properties.symbolize_keys!

      c = Community.build
      c.assign_attributes(
        name: properties[:name],
        latitude: properties[:latitude],
        longitude: properties[:longitude],
        ansi_code: properties[:ansi_code],
        fips_code: properties[:fips_code],
        aedg_id: properties[:community_id],
        global_id: properties[:global_id]
      )
      c
    end
  end
end
