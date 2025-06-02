require 'test_helper'
require 'rgeo'

class HouseDistrictAttributesTest < ActiveSupport::TestCase
  def setup
    @geom_factory = RGeo::Geographic.simple_mercator_factory

    polygon = @geom_factory.polygon(
      @geom_factory.linear_ring([
                                  @geom_factory.point(0, 0),
                                  @geom_factory.point(0, 1),
                                  @geom_factory.point(1, 1),
                                  @geom_factory.point(1, 0),
                                  @geom_factory.point(0, 0)
                                ])
    )

    @polygon_geom = @geom_factory.multi_polygon([polygon])

    @valid_props = {
      name: 'Test House District',
      district: 1000,
      as_of_date: '2023-01-01'
    }
  end

  test 'creates a new house district with geometry and attributes' do
    house_district = nil

    assert_difference -> { HouseDistrict.count }, +1 do
      house_district = HouseDistrict.import_aedg_with_geom!(@valid_props, @polygon_geom)
    end

    assert_equal @valid_props[:name], house_district.name
    assert_equal @valid_props[:district], house_district.district
    assert_equal Date.parse(@valid_props[:as_of_date]), house_district.as_of_date
    assert_equal @polygon_geom.as_text, house_district.boundary.as_text
  end

  test 'is invalid with incorrect geometry type' do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])

    assert_raises ActiveRecord::RecordInvalid do
      HouseDistrict.import_aedg_with_geom!(@valid_props, line)
    end
  end
end
