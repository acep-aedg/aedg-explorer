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

  test "import_aedg! creates a Monthly Generation Record" do
    mg = nil
    assert_difference -> { MonthlyGeneration.count }, +1 do
      mg = MonthlyGeneration.import_aedg!(@valid_props)
    end

    assert_equal @plant, mg.plant
    assert_equal @valid_props[:generation_mwh], mg.generation_mwh
    assert_equal @valid_props[:fuel_type_code], mg.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], mg.fuel_type_name
    assert_equal @valid_props[:year], mg.year
    assert_equal @valid_props[:month], mg.month
  end

  test "fails when aea_plant_id does not resolve to a plant" do
    props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)

    assert_raises(ActiveRecord::RecordInvalid) do
      MonthlyGeneration.import_aedg!(props)
    end
  end
end
