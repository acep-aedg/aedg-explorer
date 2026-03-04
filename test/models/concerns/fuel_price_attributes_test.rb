require "test_helper"

class FuelPriceAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      reporting_season: "Test Reporting Season",
      reporting_year: 2020
    }
  end

  test "build_from_aedg builds a fuel price record in memory with valid props" do
    fp = FuelPrice.build_from_aedg(@valid_props)

    assert_instance_of FuelPrice, fp
    assert fp.new_record?
    assert fp.valid?, "Should be valid: #{fp.errors.full_messages}"

    assert_equal @community, fp.community
    assert_equal @valid_props[:reporting_season], fp.reporting_season
    assert_equal @valid_props[:reporting_year], fp.reporting_year
  end

  test "is invalid when community fips code does not match any existing community" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    fp = FuelPrice.build_from_aedg(invalid_props)

    assert_not fp.valid?
    assert_includes fp.errors[:community], "must exist"
  end
end
