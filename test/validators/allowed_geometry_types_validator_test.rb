require 'test_helper'

class GeometryTypeValidatorTest < ActiveSupport::TestCase
  class MockModel
    include ActiveModel::Model
    attr_accessor :geometry

    validates :geometry, allowed_geometry_types: { in: %w[Polygon MultiPolygon] }
  end

  test 'is valid when geometry type is allowed' do
    geometry = mock
    geometry.stubs(:geometry_type).returns(stub(type_name: 'Polygon'))

    model = MockModel.new(geometry: geometry)
    assert model.valid?
  end

  test 'is invalid when geometry type is not allowed' do
    geometry = mock
    geometry.stubs(:geometry_type).returns(stub(type_name: 'Point'))

    model = MockModel.new(geometry: geometry)
    assert_not model.valid?
    assert_includes model.errors[:geometry], 'must be one of Polygon, MultiPolygon'
  end
end
