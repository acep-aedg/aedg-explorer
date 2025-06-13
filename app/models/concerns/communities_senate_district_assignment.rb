module CommunitiesSenateDistrictAssignment
  extend ActiveSupport::Concern

  class_methods do
    def assign_senate_districts!(community, districts)
      Array(districts).each do |district|
        senate = SenateDistrict.find_by(district: district)
        next unless senate

        CommunitiesSenateDistrict.find_or_create_by!(
          community_fips_code: community.fips_code,
          senate_district_district: senate.district
        )
      end
    end
  end
end