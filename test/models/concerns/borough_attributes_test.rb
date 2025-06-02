require 'test_helper'
require 'rgeo'

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
      fips_code: '123',
      name: 'Test Borough'
    }
  end

  test 'import_aedg_with_geom! creates borough with valid props and geometry' do
    borough = nil
    assert_difference -> { Borough.count }, +1 do
      borough = Borough.import_aedg_with_geom!(@valid_props, @polygon_geom)
    end
    assert_equal @valid_props[:name], borough.name
    assert_equal @valid_props[:fips_code], borough.fips_code
    assert_equal @polygon_geom.as_text, borough.boundary.as_text
  end

  test 'import_aedg_with_geom! raises error with incorrect geometry type' do
    line = @geom_factory.line_string([
                                       @geom_factory.point(0, 0),
                                       @geom_factory.point(1, 1)
                                     ])

    assert_raises ActiveRecord::RecordInvalid do
      Borough.import_aedg_with_geom!(@valid_props, line)
    end
  end

  test 'import_aedg_with_geom! raises ArgumentError with missing geometry' do
    assert_raises(ArgumentError) do
      Borough.import_aedg_with_geom!(@valid_props)
    end
  end
end
