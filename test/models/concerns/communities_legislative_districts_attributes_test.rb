require 'test_helper'

class CommunitiesLegislativeDistrictTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = communities(:one)
    @house_district = house_districts(:one)
    @senate_district = senate_districts(:one)
    @election_region = 1

    @valid_props = {
      community_fips_code: @community.fips_code,
      house_district: @house_district.district,
      senate_district: @senate_district.district,
      election_region: @election_region
    }
  end

  test 'import_aedg! creates community legislative district with valid props' do
    assert_difference -> { CommunitiesLegislativeDistrict.count }, 1 do
      cld = CommunitiesLegislativeDistrict.import_aedg!(@valid_props)
      assert_equal @community, cld.community
      assert_equal @house_district, cld.house_district
      assert_equal @senate_district, cld.senate_district
      assert_equal @election_region, cld.election_region
    end
  end

  test 'import_aedg! raises RecordNotFound when community is missing' do
    invalid_props = @valid_props.merge(community_fips_code: nil)

    assert_no_difference -> { CommunitiesLegislativeDistrict.count } do
      assert_raises(ActiveRecord::RecordNotFound) do
        CommunitiesLegislativeDistrict.import_aedg!(invalid_props)
      end
    end
  end

  test 'import_aedg! raises RecordNotFound when house district is missing' do
    invalid_props = @valid_props.merge(house_district: nil)
    assert_no_difference -> { CommunitiesLegislativeDistrict.count } do
      assert_raises(ActiveRecord::RecordNotFound) do
        CommunitiesLegislativeDistrict.import_aedg!(invalid_props)
      end
    end
  end

  test 'import_aedg! raises RecordNotFound when senate district is missing' do
    invalid_props = @valid_props.merge(senate_district: nil)
    assert_no_difference -> { CommunitiesLegislativeDistrict.count } do
      assert_raises(ActiveRecord::RecordNotFound) do
        CommunitiesLegislativeDistrict.import_aedg!(invalid_props)
      end
    end
  end
end
