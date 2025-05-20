require 'test_helper'

class TransportationAttributesTest < ActiveSupport::TestCase
  def setup
    @community = Community.new(fips_code: '000000')
    @community.save(validate: false)

    @valid_props = {
      'community_fips_code' => @community.fips_code,
      'airport' => true,
      'harbor_dock' => true,
      'state_ferry' => true,
      'cargo_barge' => true,
      'road_connection' => true,
      'coastal' => true,
      'road_or_ferry' => true,
      'description' => 'Test description',
      'as_of_date' => '2023-10-01'
    }
  end

  test 'creates a new transportation with attributes' do
    transportation = nil
    assert_difference -> { Transportation.count }, +1 do
      transportation = Transportation.import_aedg!(@valid_props)
    end

    assert_equal @community, transportation.community
    assert_equal @valid_props[:community_fips_code], transportation.community_fips_code
    assert_equal @valid_props[:airport], transportation.airport
    assert_equal @valid_props[:harbor_dock], transportation.harbor_dock
    assert_equal @valid_props[:state_ferry], transportation.state_ferry
    assert_equal @valid_props[:cargo_barge], transportation.cargo_barge
    assert_equal @valid_props[:road_connection], transportation.road_connection
    assert_equal @valid_props[:coastal], transportation.coastal
    assert_equal @valid_props[:road_or_ferry], transportation.road_or_ferry
    assert_equal @valid_props[:description], transportation.description
    assert_equal Date.parse(@valid_props[:as_of_date]), transportation.as_of_date
  end

  test 'does not create a duplicate transportation for the same community' do
    Transportation.import_aedg!(@valid_props)

    assert_no_difference -> { Transportation.count } do
      Transportation.import_aedg!(@valid_props)
    end
  end

  test 'raises error if community fips code does not match any community' do
    props_with_invalid_fips = @valid_props.merge('community_fips_code' => '999999')
    assert_raises(ActiveRecord::RecordInvalid) do
      Transportation.import_aedg!(props_with_invalid_fips)
    end
  end
end
