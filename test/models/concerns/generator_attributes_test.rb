require "test_helper"

class GeneratorAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @plant = Plant.create!(aea_plant_id: VALID_AEDG_ID, name: "Test Plant")
    @valid_props = {
      aea_plant_id: VALID_AEDG_ID
    }
  end

  test "import_aedg! creates generator with valid props" do
    generator = nil
    assert_difference -> { Generator.count }, +1 do
      generator = Generator.import_aedg!(@valid_props)
    end
    assert_equal @plant, generator.plant
  end

  test "import_aedg! raises RecordInvalid when associated plant does not exist" do
    invalid_props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)
    assert_raises(ActiveRecord::RecordInvalid) do
      Generator.import_aedg!(invalid_props)
    end
  end
end
