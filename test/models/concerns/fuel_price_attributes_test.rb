require 'test_helper'

class FuelPriceAttributesTest < ActiveSupport::TestCase
  VALID_FIPS_CODE = '000000'.freeze
  INVALID_FIPS_CODE = '999999'.freeze

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: @community.fips_code,
      price: 2.5,
      fuel_type: 'Test Fuel Type',
      price_type: 'Test Price Type',
      source: 'Test Source',
      reporting_season: 'Test Reporting Season',
      reporting_year: 2020
    }
  end

  test 'creates a new fuel price record' do
    fp = nil
    assert_difference -> { FuelPrice.count }, +1 do
      fp = FuelPrice.import_aedg!(@valid_props)
    end

    assert_equal @community, fp.community
    assert_equal @valid_props[:price], fp.price
    assert_equal @valid_props[:fuel_type], fp.fuel_type
    assert_equal @valid_props[:price_type], fp.price_type
    assert_equal @valid_props[:source], fp.source
    assert_equal @valid_props[:reporting_season], fp.reporting_season
    assert_equal @valid_props[:reporting_year], fp.reporting_year
  end

  test 'does not create a duplicate fuel price for the same community' do
    FuelPrice.import_aedg!(@valid_props)

    assert_no_difference -> { Transportation.count } do
      FuelPrice.import_aedg!(@valid_props)
    end
  end

  test 'raises error if community fips code does not match any community' do
    props_with_invalid_fips = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      FuelPrice.import_aedg!(props_with_invalid_fips)
    end
  end
end
