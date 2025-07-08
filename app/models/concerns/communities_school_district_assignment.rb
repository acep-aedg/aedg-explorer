module CommunitiesSchoolDistrictAssignment
  extend ActiveSupport::Concern

  class_methods do
    def assign_school_districts!(community, districts)
      Array(districts).each do |district|
        school = SchoolDistrict.find_by(district: district)
        next unless school

        CommunitiesSchoolDistrict.find_or_create_by!(
          community_fips_code: community.fips_code,
          school_district_district: school.district
        )
      end
    end
  end
end
