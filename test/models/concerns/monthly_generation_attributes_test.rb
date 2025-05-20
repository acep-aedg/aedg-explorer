require 'test_helper'

class MonthlyGenerationAttributesTest < ActiveSupport::TestCase
  VALID_AEGD_ID = 1
  INVALID_AEGD_ID = 9999

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEGD_ID, name: 'Stub Grid')
    Grid.stubs(:from_aedg_id).with(VALID_AEGD_ID).returns([@grid])

    @valid_props = {
      grid_id: VALID_AEGD_ID,
      net_generation_mwh: 10,
      fuel_type_code: 'TEST',
      fuel_type_name: 'Test Fuel Type',
      year: 2021,
      month: 1
    }
  end

  test 'import_aedg! creates a Monthly Generation Record' do
    assert_difference -> { MonthlyGeneration.count }, +1 do
      mg = MonthlyGeneration.import_aedg!(@valid_props)
      assert_equal @grid, mg.grid
      assert_equal @valid_props[:net_generation_mwh], mg.net_generation_mwh
      assert_equal @valid_props[:fuel_type_code], mg.fuel_type_code
      assert_equal @valid_props[:fuel_type_name], mg.fuel_type_name
      assert_equal @valid_props[:year], mg.year
      assert_equal @valid_props[:month], mg.month
    end
  end

  test 'fails when grid_id does not resolve to a grid' do
    Grid.stubs(:from_aedg_id).with(INVALID_AEGD_ID).returns([])
    props = @valid_props.merge(grid_id: INVALID_AEGD_ID)

    assert_raises(ActiveRecord::RecordInvalid) do
      MonthlyGeneration.import_aedg!(props)
    end
  end
end
