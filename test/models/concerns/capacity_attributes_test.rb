require 'test_helper'

class CapacityAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEDG_ID, name: 'Test Grid')
    @valid_props = {
      grid_id: VALID_AEDG_ID,
      capacity_mw: 10,
      fuel_type_code: 'TEST',
      fuel_type_name: 'Test Fuel Type',
      year: 2021
    }
  end

  test 'import_aedg! creates capacity with valid props' do
    capacity = nil
    assert_difference -> { Capacity.count }, +1 do
      capacity = Capacity.import_aedg!(@valid_props)
    end
    assert_equal @grid, capacity.grid
    assert_equal @valid_props[:capacity_mw], capacity.capacity_mw
    assert_equal @valid_props[:fuel_type_code], capacity.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], capacity.fuel_type_name
    assert_equal @valid_props[:year], capacity.year
  end

  test 'import_aedg! raises RecordInvalid when associated grid does not exist' do
    invalid_props = @valid_props.merge(grid_id: INVALID_AEDG_ID)
    assert_raises(ActiveRecord::RecordInvalid) do
      Capacity.import_aedg!(invalid_props)
    end
  end
end
