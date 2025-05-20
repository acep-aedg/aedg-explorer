require 'test_helper'

class YearlyGenerationAttributesTest < ActiveSupport::TestCase
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
      year: 2021
    }
  end

  test 'import_aedg! creates a Yearly Generation Record' do
    assert_difference -> { YearlyGeneration.count }, +1 do
      yg = YearlyGeneration.import_aedg!(@valid_props)
      assert_equal @grid, yg.grid
      assert_equal @valid_props[:net_generation_mwh], yg.net_generation_mwh
      assert_equal @valid_props[:fuel_type_code], yg.fuel_type_code
      assert_equal @valid_props[:fuel_type_name], yg.fuel_type_name
      assert_equal @valid_props[:year], yg.year
    end
  end

  test 'fails to create Yearly Generation when grid does not exist' do
    Grid.stubs(:from_aedg_id).with(INVALID_AEGD_ID).returns([])
    props = @valid_props.merge(grid_id: INVALID_AEGD_ID)

    assert_raises(ActiveRecord::RecordInvalid) do
      YearlyGeneration.import_aedg!(props)
    end
  end
end
