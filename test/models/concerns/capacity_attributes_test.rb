require "test_helper"

class CapacityAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @plant = Plant.create!(aea_plant_id: VALID_AEDG_ID, name: "Test Plant")
    @valid_props = {
      aea_plant_id: VALID_AEDG_ID,
      nameplate_capacity_mw: 10,
      fuel_type_code: "TEST",
      fuel_type_name: "Test Fuel Type",
      year: 2021
    }
  end

  test "build_from_aedg correctly associates to plant via aea_plant_id" do
    capacity = Capacity.build_from_aedg(@valid_props)
    assert_equal VALID_AEDG_ID, capacity.aea_plant_id
    assert_equal @plant, capacity.plant
    assert_equal @valid_props[:nameplate_capacity_mw], capacity.capacity_mw
    assert_equal @valid_props[:fuel_type_code], capacity.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], capacity.fuel_type_name
    assert_equal @valid_props[:year], capacity.year
    assert capacity.valid?, "Should be valid when plant exists"
  end

  test "build_from_aedg is invalid when aea_plant_id matches no plant" do
    invalid_props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)
    capacity = Capacity.build_from_aedg(invalid_props)

    assert_not capacity.valid?
    assert_includes capacity.errors[:plant], "must exist"
  end
end
