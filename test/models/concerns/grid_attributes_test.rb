require 'test_helper'

class GridAttributesTest < ActiveSupport::TestCase
  test "import_aedg! creates a Grid with correct attributes" do
    assert_difference -> { Grid.count }, +1 do
      grid = Grid.import_aedg!({ "id" => 1, "name" => "Grid Test" })
      assert_equal "Grid Test", grid.name
      assert_equal 1, grid.aedg_id
    end
  end

  test "import_aedg! raises error if id is missing" do
    assert_raises(RuntimeError, "id is required") do
      Grid.import_aedg!({ "name" => "No ID Grid" })
    end
  end

  test "import_aedg! raises error if aedg_id already exists for Grid" do
    Grid.import_aedg!({ "id" => 1, "name" => "Original Grid" })

    assert_raises ActiveRecord::RecordInvalid do
      Grid.import_aedg!({ "id" => 1, "name" => "Duplicate Grid" })
    end
  end
end