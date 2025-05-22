require 'test_helper'

class ReportingEntityAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEDG_ID, name: 'Test Grid')
    @valid_props = {
      id: VALID_AEDG_ID,
      name: 'Test Utility',
      year: 2021,
      grid_id: VALID_AEDG_ID
    }
  end
  test 'import_aedg! creates a reporting entity record with valid props' do
    reporting_entity = nil
    assert_difference -> { ReportingEntity.count }, +1 do
      reporting_entity = ReportingEntity.import_aedg!(@valid_props)
    end

    assert_equal @valid_props[:name], reporting_entity.name
    assert_equal @valid_props[:id], reporting_entity.aedg_id
    assert_equal @valid_props[:year], reporting_entity.year
    assert_equal @grid, reporting_entity.grid
  end

  test 'import_aedg! raises RuntimeError when missing id' do
    invalid_props = @valid_props.merge(id: nil)
    assert_raises(RuntimeError, 'id is required') do
      ReportingEntity.import_aedg!(invalid_props)
    end
  end

  test 'import_aedg! raises RecordInvalid when associated grid does not exist' do
    invalid_props = @valid_props.merge(grid_id: INVALID_AEDG_ID)
    assert_raises(ActiveRecord::RecordInvalid) do
      ReportingEntity.import_aedg!(invalid_props)
    end
  end
end
