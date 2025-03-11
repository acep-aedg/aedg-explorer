module CommunitiesLegislativeDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      CommunitiesLegislativeDistrict.new.tap do |cld|
        cld.assign_aedg_attributes(properties)
        cld.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:communities_fips_code],
        house_district: params[:house_district],
        senate_district: params[:senate_district],
        election_region: params[:election_region],
      )
    end
  end
end
