require "test_helper"

class TransportationAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      airport: true,
      harbor_dock: true,
      state_ferry: true,
      cargo_barge: true,
      road_connection: true,
      coastal: true,
      road_or_ferry: true,
      description: "Test description",
      as_of_date: "2023-10-01"
    }
  end

  test "import_aedg! creates a transportation record with valid props" do
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

  test "import_aedg! does not create duplicate transportation for the same community" do
    Transportation.import_aedg!(@valid_props)

    assert_no_difference -> { Transportation.count } do
      Transportation.import_aedg!(@valid_props)
    end
  end

  test "import_aedg! raises RecordInvalid when no matching community is found" do
    props_with_invalid_fips = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      Transportation.import_aedg!(props_with_invalid_fips)
    end
  end
end
