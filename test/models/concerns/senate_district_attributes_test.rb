require "test_helper"
require "rgeo"

class SenateDistrictAttributesTest < ActiveSupport::TestCase
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
      district: "ABC",
      as_of_date: "2022-01-01"
    }
  end

  test "creates a new senate district with geometry and attributes" do
    senate_district = nil
    assert_difference -> { SenateDistrict.count }, +1 do
      senate_district = SenateDistrict.import_aedg_with_geom!(@valid_props, @polygon_geom)
    end
    assert_equal @valid_props[:district], senate_district.district
    assert_equal Date.parse(@valid_props[:as_of_date]), senate_district.as_of_date
    assert_equal @polygon_geom, senate_district.boundary
  end

  test "is invalid with incorrect geometry type" do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])

    assert_raises ActiveRecord::RecordInvalid do
      SenateDistrict.import_aedg_with_geom!(@valid_props, line)
    end
  end
end
