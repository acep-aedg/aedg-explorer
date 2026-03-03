require "test_helper"

class TransportationAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      airport: true,
      description: "Test description",
      as_of_date: "2023-10-01"
    }
  end

  test "build_from_aedg builds a transportation record with valid props" do
    transportation = Transportation.build_from_aedg(@valid_props)

    assert_instance_of Transportation, transportation
    assert transportation.new_record?
    assert transportation.valid?, "Should be valid: #{transportation.errors.full_messages}"

    assert_equal @community, transportation.community
    assert_equal true, transportation.airport
    assert_equal Date.parse("2023-10-01"), transportation.as_of_date
  end

  test "is invalid when community_fips_code is missing" do
    transportation = Transportation.build_from_aedg(@valid_props.except(:community_fips_code))

    assert_not transportation.valid?
    assert_includes transportation.errors[:community_fips_code], "can't be blank"
  end

  test "is invalid when community does not exist in the database" do
    props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    transportation = Transportation.build_from_aedg(props)

    assert_not transportation.valid?
    assert_includes transportation.errors[:community], "must exist"
  end
end
