# app/models/concerns/community_attributes.rb
module CommunityAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties)
      assign_attributes(
        name: properties['name'],
        latitude: properties['latitude'],
        longitude: properties['longitude'],
        ansi_code: properties['ansi_code'],
        community_id: properties['community_id'],
        global_id: properties['global_id']
      )
    end
  end
end