# app/models/concerns/transportation_attributes.rb
module TransportationAttributes
  extend ActiveSupport::Concern

  class_methods do 
    def import_aedg!(properties)
      properties.symbolize_keys!

      Transportation.find_or_initialize_by(community_fips_code: properties[:community_fips_code]).tap do |transportation|
        transportation.assign_aedg_attributes(properties)
        transportation.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        airport: params[:airport],
        harbor_dock: params[:harbor_dock],
        state_ferry: params[:state_ferry],
        cargo_barge: params[:cargo_barge],
        road_connection: params[:road_connection],
        coastal: params[:coastal],
        road_or_ferry: params[:road_or_ferry],
        description: params[:description],
        as_of_date: params[:as_of_date]
      )
    end
  end
end