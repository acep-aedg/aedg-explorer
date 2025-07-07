# app/models/concerns/community_attributes.rb
module CommunityAttributes
  extend ActiveSupport::Concern
  include CommunitiesSenateDistrictAssignment
  include CommunitiesHouseDistrictAssignment

  class_methods do
    def import_aedg_with_geom!(properties, geom)
      properties['location'] = geom
      properties.symbolize_keys!

      Community.find_or_initialize_by(fips_code: properties[:fips_code]).tap do |community|
        community.assign_aedg_attributes(properties)
        community.save!

        assign_senate_districts!(community, properties[:senate_district])
        assign_house_districts!(community, properties[:house_district])
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        fips_code: params[:fips_code],
        name: params[:name],
        regional_corporation_fips_code: params[:regional_corporation_fips_code],
        borough_fips_code: params[:borough_fips_code],
        dcra_code: params[:dcra_code],
        pce_eligible: params[:pce_eligible],
        pce_active: params[:pce_active],
        latitude: params[:latitude],
        longitude: params[:longitude],
        location: params[:location],
        gnis_code: params[:gnis_code],
        puma_code: params[:puma_code],
        subsistence: params[:subsistence],
        economic_region: params[:economic_region],
        village_corporation: params[:village_corporation],
        heating_degree_days: params[:heating_degree_days],
        reporting_entity: ReportingEntity.from_aedg_id(params[:reporting_entity_id]).first
      )
    end
  end
end
