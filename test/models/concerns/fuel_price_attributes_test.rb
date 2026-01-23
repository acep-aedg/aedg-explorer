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

  test "import_aedg! creates a fuel price record with valid props" do
    fp = nil
    assert_difference -> { FuelPrice.count }, +1 do
      fp = FuelPrice.import_aedg!(@valid_props)
    end

    assert_equal @community, fp.community
    assert_equal @valid_props[:reporting_season], fp.reporting_season
    assert_equal @valid_props[:reporting_year], fp.reporting_year
  end

  test "import_aedg! raises RecordInvalid when community fips code does not match any existing community" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      FuelPrice.import_aedg!(invalid_props)
    end
  end

  test "import_aedg! raises RecordInvalid when community fips code is nil" do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      FuelPrice.import_aedg!(invalid_props)
    end
  end
end
