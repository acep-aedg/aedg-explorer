require "test_helper"
require "rgeo"

class HouseDistrictAttributesTest < ActiveSupport::TestCase
  def setup
    # @geom_factory = RGeo::Geographic.spherical_factory(srid: 4326)
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
      name: "Test House District",
      district: 1000,
      as_of_date: "2023-01-01"
    }
  end

  test "build_from_aedg_geojson prepares a new record in memory" do
    house_district = HouseDistrict.build_from_aedg_geojson(@valid_props, @polygon_geom)

    assert_instance_of HouseDistrict, house_district
    assert house_district.new_record?
    assert house_district.valid?, "Should be valid: #{house_district.errors.full_messages}"

    assert_equal @valid_props[:name], house_district.name
    assert_equal @valid_props[:district], house_district.district
    assert_equal Date.parse(@valid_props[:as_of_date]), house_district.as_of_date
    assert_equal @polygon_geom, house_district.boundary
  end

  test "is invalid with incorrect geometry type" do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])

    house_district = HouseDistrict.build_from_aedg_geojson(@valid_props, line)

    assert_not house_district.valid?
    assert_includes house_district.errors[:boundary], "must be one of Polygon, MultiPolygon"
  end

  test "is invalid when boundary is missing" do
    house_district = HouseDistrict.build_from_aedg_geojson(@valid_props, nil)

    assert_not house_district.valid?
    assert_includes house_district.errors[:boundary], "can't be blank"
  end
end
