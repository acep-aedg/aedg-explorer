module CommunitiesHouseDistrictAssignment
  extend ActiveSupport::Concern

  class_methods do
    def assign_house_districts!(community, districts)
      Array(districts).each do |district|
        house = HouseDistrict.find_by(district: district)
        next unless house

        CommunitiesHouseDistrict.find_or_create_by!(
          community_fips_code: community.fips_code,
          house_district_district: house.district
        )
      end
    end
  end
end
