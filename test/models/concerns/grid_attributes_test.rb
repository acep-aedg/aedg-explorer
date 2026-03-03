require "test_helper"

class GridAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @valid_props = {
      id: VALID_AEDG_ID,
      name: "Test Grid"
    }
  end

  test "build_from_aedg builds a grid in memory with valid props" do
    grid = Grid.build_from_aedg(@valid_props)

    assert_instance_of Grid, grid
    assert grid.new_record?
    assert_equal @valid_props[:name], grid.name
    assert_equal @valid_props[:id], grid.aedg_import.aedg_id
  end

  test "build_from_aedg raises error if id is missing" do
    invalid_props = @valid_props.except(:id)

    assert_raises(RuntimeError, "id is required") do
      Grid.build_from_aedg(invalid_props)
    end
  end
end
