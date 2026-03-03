require "test_helper"
require "rgeo"

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
      name: "Test Regional Corporation",
      land_area: 100_000_000,
      water_area: 100_000_000
    }
  end

  test "build_from_aedg_geojson builds a record in memory with valid props and geom" do
    reg_corp = RegionalCorporation.build_from_aedg_geojson(@valid_props, @polygon_geom)

    assert_instance_of RegionalCorporation, reg_corp
    assert reg_corp.new_record?
    assert reg_corp.valid?, "Should be valid: #{reg_corp.errors.full_messages}"

    assert_equal @valid_props[:fips_code], reg_corp.fips_code
    assert_equal @valid_props[:name], reg_corp.name
    assert_equal @polygon_geom, reg_corp.boundary
  end

  test "is invalid when boundary is missing" do
    # Matches validates :boundary, presence: true
    reg_corp = RegionalCorporation.build_from_aedg_geojson(@valid_props, nil)

    assert_not reg_corp.valid?
    assert_includes reg_corp.errors[:boundary], "can't be blank"
  end

  test "is invalid when geometry type is not a polygon" do
    point_geom = @geom_factory.point(0, 0)
    reg_corp = RegionalCorporation.build_from_aedg_geojson(@valid_props, point_geom)

    assert_not reg_corp.valid?
    assert_includes reg_corp.errors[:boundary], "must be one of Polygon, MultiPolygon"
  end

  test "is invalid if the fips_code already exists" do
    RegionalCorporation.create!(@valid_props.merge(boundary: @polygon_geom))
    duplicate = RegionalCorporation.build_from_aedg_geojson(@valid_props, @polygon_geom)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:fips_code], "has already been taken"
  end
end
