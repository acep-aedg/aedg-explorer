require 'test_helper'

class CapacityAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @plant = Plant.create!(aea_plant_id: VALID_AEDG_ID, name: 'Test Plant')
    @valid_props = {
      aea_plant_id: VALID_AEDG_ID,
      nameplate_capacity_mw: 10,
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
    assert_equal @plant, capacity.plant
    assert_equal @valid_props[:nameplate_capacity_mw], capacity.capacity_mw
    assert_equal @valid_props[:fuel_type_code], capacity.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], capacity.fuel_type_name
    assert_equal @valid_props[:year], capacity.year
  end

  test 'import_aedg! raises RecordInvalid when associated plant does not exist' do
    invalid_props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)
    assert_raises(ActiveRecord::RecordInvalid) do
      Capacity.import_aedg!(invalid_props)
    end
  end
end
