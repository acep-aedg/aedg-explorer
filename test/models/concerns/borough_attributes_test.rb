require "test_helper"
require "rgeo"

class BoroughAttributesTest < ActiveSupport::TestCase
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
      fips_code: "000001",
      name: "Test Borough"
    }
  end

  test "build_from_aedg_geojson builds a borough object in memory" do
    borough = Borough.build_from_aedg_geojson(@valid_props, @polygon_geom)

    assert_instance_of Borough, borough
    assert_equal "000001", borough.fips_code
    assert_equal "Test Borough", borough.name
    assert_equal @polygon_geom, borough.boundary
    assert borough.new_record?
  end

  test "build_from_aedg_geojson results in an invalid borough with incorrect geometry type" do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])
    borough = Borough.build_from_aedg_geojson(@valid_props, line)
    assert_not borough.valid?, "Borough should be invalid with a LineString boundary"
    assert_includes borough.errors[:boundary], "must be one of Polygon, MultiPolygon"
  end

  test "build_from_aedg_geojson raises ArgumentError with missing geometry argument" do
    assert_raises(ArgumentError) do
      Borough.build_from_aedg_geojson(@valid_props)
    end
  end
end
