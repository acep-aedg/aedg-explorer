require 'test_helper'
require 'rgeo'

class SchoolDistrictAttributesTest < ActiveSupport::TestCase
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
      id: 123,
      name: 'Test School District',
      type: 'REAA',
      is_active: true,
      notes: 'A test district for unit testing'
    }
  end

  test 'creates a new school district with geometry and attributes' do
    district = nil
    assert_difference -> { SchoolDistrict.count }, +1 do
      district = SchoolDistrict.import_aedg_with_geom!(@valid_props, @polygon_geom)
    end

    assert_equal @valid_props[:name], district.name
    assert_equal @valid_props[:type], district.district_type
    assert_equal @valid_props[:is_active], district.is_active
    assert_equal @valid_props[:notes], district.notes
    assert_equal @polygon_geom.as_text, district.boundary.as_text
  end

  test 'is invalid with incorrect geometry type' do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])

    assert_raises ActiveRecord::RecordInvalid do
      SchoolDistrict.import_aedg_with_geom!(@valid_props, line)
    end
  end
end
