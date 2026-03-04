require "test_helper"
require "rgeo"

class SenateDistrictAttributesTest < ActiveSupport::TestCase
  def setup
    column_type = HouseDistrict.type_for_attribute(:boundary)
    @geom_factory = column_type.spatial_factory

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

  test "build_from_aedg_geojson builds a new record in memory with geometry and attributes" do
    senate_district = SenateDistrict.build_from_aedg_geojson(@valid_props, @polygon_geom)

    assert_instance_of SenateDistrict, senate_district
    assert senate_district.new_record?
    assert senate_district.valid?, "Should be valid: #{senate_district.errors.full_messages}"

    assert_equal @valid_props[:district], senate_district.district
    assert_equal Date.parse(@valid_props[:as_of_date]), senate_district.as_of_date
    assert_equal @polygon_geom, senate_district.boundary
  end

  test "is invalid with incorrect geometry type" do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])

    senate_district = SenateDistrict.build_from_aedg_geojson(@valid_props, line)

    assert_not senate_district.valid?
    assert_includes senate_district.errors[:boundary], "must be one of Polygon, MultiPolygon"
  end

  test "is invalid when boundary is missing" do
    senate_district = SenateDistrict.build_from_aedg_geojson(@valid_props, nil)

    assert_not senate_district.valid?
    assert_includes senate_district.errors[:boundary], "can't be blank"
  end
end
