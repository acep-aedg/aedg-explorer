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
      house_district_number = params[:house_district].to_i
      house_district = HouseDistrict.find_by!(district: house_district_number)
      senate_district = SenateDistrict.find_by!(district: params[:senate_district])
      community = Community.find_by!(fips_code: params[:communities_fips_code])

      assign_attributes(
        community: community,
        house_district: house_district,
        senate_district: senate_district,
        election_region: params[:election_region]
      )
    end
  end
end
