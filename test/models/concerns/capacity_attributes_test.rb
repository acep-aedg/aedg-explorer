require 'test_helper'

class CapacityAttributesTest < ActiveSupport::TestCase
  VALID_AEGD_ID = 1
  INVALID_AEGD_ID = 9999

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEGD_ID, name: 'Stub Grid')
    Grid.stubs(:from_aedg_id).with(VALID_AEGD_ID).returns([@grid])

    @valid_props = {
      grid_id: VALID_AEGD_ID,
      capacity_mw: 10,
      fuel_type_code: 'TEST',
      fuel_type_name: 'Test Fuel Type',
      year: 2021
    }
  end

  test 'import_aedg! creates a capacity with correct attributes using stubbed grid' do
    assert_difference -> { Capacity.count }, +1 do
      capacity = Capacity.import_aedg!(@valid_props)
      assert_equal @grid, capacity.grid
      assert_equal @valid_props[:capacity_mw], capacity.capacity_mw
      assert_equal @valid_props[:fuel_type_code], capacity.fuel_type_code
      assert_equal @valid_props[:fuel_type_name], capacity.fuel_type_name
      assert_equal @valid_props[:year], capacity.year
    end
  end

  test 'fails when grid_id does not resolve to a grid' do
    Grid.stubs(:from_aedg_id).with(INVALID_AEGD_ID).returns([])
    props = @valid_props.merge(grid_id: INVALID_AEGD_ID)

    assert_raises(ActiveRecord::RecordInvalid) do
      Capacity.import_aedg!(props)
    end
  end
end
