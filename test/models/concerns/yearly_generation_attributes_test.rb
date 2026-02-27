require "test_helper"

class YearlyGenerationAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @plant = Plant.create!(aea_plant_id: VALID_AEDG_ID, name: "Test Plant")
    @valid_props = {
      aea_plant_id: VALID_AEDG_ID,
      generation_mwh: 10,
      fuel_type_code: "TEST",
      fuel_type_name: "Test Fuel Type",
      year: 2021
    }
  end

  test "build_from_aedg builds a yearly generation record in memory with valid props" do
    yg = YearlyGeneration.build_from_aedg(@valid_props)

    assert_instance_of YearlyGeneration, yg
    assert yg.new_record?
    assert yg.valid?, "YearlyGeneration should be valid: #{yg.errors.full_messages}"

    assert_equal @plant, yg.plant
    assert_equal @valid_props[:generation_mwh], yg.generation_mwh
    assert_equal @valid_props[:fuel_type_code], yg.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], yg.fuel_type_name
    assert_equal @valid_props[:year], yg.year
  end

  test "build_from_aedg results in an invalid record when plant cannot be found" do
    invalid_props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)
    yg = YearlyGeneration.build_from_aedg(invalid_props)

    assert_not yg.valid?
    assert_includes yg.errors[:plant], "must exist"
  end

  test "build_from_aedg is invalid when aea_plant_id is missing" do
    invalid_props = @valid_props.except(:aea_plant_id)
    yg = YearlyGeneration.build_from_aedg(invalid_props)

    assert_not yg.valid?
    assert_includes yg.errors[:plant], "must exist"
  end
end
