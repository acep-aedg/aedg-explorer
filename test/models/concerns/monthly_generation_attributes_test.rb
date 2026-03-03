require "test_helper"

class MonthlyGenerationAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @plant = Plant.create!(aea_plant_id: VALID_AEDG_ID, name: "Test Plant")
    @valid_props = {
      aea_plant_id: VALID_AEDG_ID,
      generation_mwh: 10,
      fuel_type_code: "ABC",
      fuel_type_name: "Test Fuel Type",
      year: 2021,
      month: 1
    }
  end

  test "build_from_aedg builds a monthly generation record in memory with valid props" do
    mg = MonthlyGeneration.build_from_aedg(@valid_props)

    assert_instance_of MonthlyGeneration, mg
    assert mg.new_record?
    assert mg.valid?, "MonthlyGeneration should be valid: #{mg.errors.full_messages}"

    assert_equal @plant, mg.plant
    assert_equal @valid_props[:generation_mwh], mg.generation_mwh
    assert_equal @valid_props[:fuel_type_code], mg.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], mg.fuel_type_name
    assert_equal @valid_props[:year], mg.year
    assert_equal @valid_props[:month], mg.month
  end

  test "build_from_aedg results in an invalid record when aea_plant_id cannot be resolved" do
    invalid_props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)
    mg = MonthlyGeneration.build_from_aedg(invalid_props)

    assert_not mg.valid?
    assert_includes mg.errors[:plant], "must exist"
  end

  test "build_from_aedg is invalid when month is missing" do
    invalid_props = @valid_props.except(:month)
    mg = MonthlyGeneration.build_from_aedg(invalid_props)

    assert_not mg.valid?
    assert_includes mg.errors[:month], "can't be blank"
  end
end
