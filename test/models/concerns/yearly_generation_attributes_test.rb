require 'test_helper'

class YearlyGenerationAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEDG_ID, name: 'Test Grid')
    @valid_props = {
      grid_id: VALID_AEDG_ID,
      net_generation_mwh: 10,
      fuel_type_code: 'TEST',
      fuel_type_name: 'Test Fuel Type',
      year: 2021
    }
  end

  test 'import_aedg! creates a yearly generation record with valid props' do
    yg = nil

    assert_difference -> { YearlyGeneration.count }, +1 do
      yg = YearlyGeneration.import_aedg!(@valid_props)
    end

    assert_equal @grid, yg.grid
    assert_equal @valid_props[:net_generation_mwh], yg.net_generation_mwh
    assert_equal @valid_props[:fuel_type_code], yg.fuel_type_code
    assert_equal @valid_props[:fuel_type_name], yg.fuel_type_name
    assert_equal @valid_props[:year], yg.year
  end

  test 'import_aedg! raises RecordInvalid when associated grid cannot be found' do
    invalid_props = @valid_props.merge(grid_id: INVALID_AEDG_ID)
    assert_raises(ActiveRecord::RecordInvalid) do
      YearlyGeneration.import_aedg!(invalid_props)
    end
  end
end
