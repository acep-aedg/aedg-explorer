require "test_helper"

class GeneratorAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @plant = Plant.create!(aea_plant_id: VALID_AEDG_ID, name: "Test Plant")
    @valid_props = {
      aea_plant_id: VALID_AEDG_ID
    }
  end

  test "build_from_aedg builds generator with valid props in memory" do
    generator = Generator.build_from_aedg(@valid_props)

    assert_instance_of Generator, generator
    assert generator.new_record?
    assert generator.valid?, "Generator should be valid: #{generator.errors.full_messages}"

    assert_equal @plant, generator.plant
    assert_equal VALID_AEDG_ID, generator.aea_plant_id
  end

  test "build_from_aedg results in an invalid record when associated plant does not exist" do
    invalid_props = @valid_props.merge(aea_plant_id: INVALID_AEDG_ID)

    generator = Generator.build_from_aedg(invalid_props)

    assert_not generator.valid?
    assert_includes generator.errors[:plant], "must exist"
  end
end
