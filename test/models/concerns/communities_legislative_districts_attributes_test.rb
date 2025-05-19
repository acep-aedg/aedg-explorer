require 'test_helper'

class CommunitiesLegislativeDistrictTest < ActiveSupport::TestCase
  setup do
    @community = communities(:one)
    @house_district = house_districts(:one)
    @senate_district = senate_districts(:one)
    @election_region = 1
  end

  test 'import_aedg! creates a community legislative district with correct attributes' do
    attributes = {
      community_fips_code: @community.fips_code,
      house_district: @house_district.district,
      senate_district: @senate_district.district,
      election_region: @election_region
    }

    assert_difference -> { CommunitiesLegislativeDistrict.count }, 1 do
      cld = CommunitiesLegislativeDistrict.import_aedg!(attributes)
      assert_equal @community, cld.community
      assert_equal @house_district, cld.house_district
      assert_equal @senate_district, cld.senate_district
      assert_equal @election_region, cld.election_region
    end
  end

  test 'import_aedg! fails when community is missing' do
    attributes = {
      community_fips_code: '999999',
      house_district: @house_district.district,
      senate_district: @senate_district.district,
      election_region: @election_region
    }

    assert_no_difference -> { CommunitiesLegislativeDistrict.count } do
      assert_raises ActiveRecord::RecordNotFound do
        CommunitiesLegislativeDistrict.import_aedg!(attributes)
      end
    end
  end

  test 'import_aedg! fails when house district is missing' do
    attributes = {
      community_fips_code: @community.fips_code,
      house_district: '999999',
      senate_district: @senate_district.district,
      election_region: @election_region
    }

    assert_no_difference -> { CommunitiesLegislativeDistrict.count } do
      assert_raises ActiveRecord::RecordNotFound do
        CommunitiesLegislativeDistrict.import_aedg!(attributes)
      end
    end
  end

  test 'import_aedg! fails when senate district is missing' do
    attributes = {
      community_fips_code: @community.fips_code,
      house_district: @house_district.district,
      senate_district: '999999',
      election_region: @election_region
    }

    assert_no_difference -> { CommunitiesLegislativeDistrict.count } do
      assert_raises ActiveRecord::RecordNotFound do
        CommunitiesLegislativeDistrict.import_aedg!(attributes)
      end
    end
  end
end
