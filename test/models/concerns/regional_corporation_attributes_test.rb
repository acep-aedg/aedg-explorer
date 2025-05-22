require 'test_helper'
require 'rgeo'

class RegionalCorporationAttributesTest < ActiveSupport::TestCase
  include TestConstants
  def setup
    @geom_factory = RGeo::Geographic.simple_mercator_factory

    @polygon_geom = @geom_factory.polygon(
      @geom_factory.linear_ring([
                                  @geom_factory.point(0, 0),
                                  @geom_factory.point(0, 1),
                                  @geom_factory.point(1, 1),
                                  @geom_factory.point(1, 0),
                                  @geom_factory.point(0, 0)
                                ])
    )

    @valid_props = {
      fips_code: VALID_FIPS_CODE,
      name: 'Test Regional Corporation',
      land_area: 100_000_000,
      water_area: 100_000_000
    }
  end

  test 'import_aedg_with_geom! creates a regional corporation record with vaild props and geom' do
    reg_corp = nil
    assert_difference -> { RegionalCorporation.count }, +1 do
      reg_corp = RegionalCorporation.import_aedg_with_geom!(@valid_props, @polygon_geom)
    end
    assert_equal @valid_props[:fips_code], reg_corp.fips_code
    assert_equal @valid_props[:name], reg_corp.name
    assert_equal @valid_props[:land_area], reg_corp.land_area
    assert_equal @valid_props[:water_area], reg_corp.water_area
    assert_equal @polygon_geom.as_text, reg_corp.boundary.as_text
  end

  test 'import_aedg_with_geom! raises RecordInvalid when fips_code is missing' do
    invalid_props = @valid_props.merge(fips_code: nil)

    assert_no_difference -> { RegionalCorporation.count } do
      assert_raises ActiveRecord::RecordInvalid do
        RegionalCorporation.import_aedg_with_geom!(invalid_props, @polygon_geom)
      end
    end
  end

  test 'import_aedg_with_geom! raises ArgumentError when geometry is not provided' do
    assert_no_difference -> { RegionalCorporation.count } do
      assert_raises ArgumentError do
        RegionalCorporation.import_aedg_with_geom!(@valid_props)
      end
    end
  end
end
