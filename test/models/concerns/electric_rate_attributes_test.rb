require 'test_helper'

class ElectricRateAttributesTest < ActiveSupport::TestCase
  VALID_AEDG_ID = 1111
  INVALID_AEDG_ID = 9999

  def setup
    @grid = grids(:one)
    @reporting_entity = ReportingEntity.create!(aedg_id: VALID_AEDG_ID, name: 'Test Utility', year: 2021, grid: @grid)
    @valid_props = {
      reporting_entity_id: VALID_AEDG_ID,
      year: 2021,
      residential_rate: 0.2
    }
  end
  test 'import_aedg! creates electric rate with valid props' do
    ReportingEntity.stubs(:from_aedg_id).with(VALID_AEDG_ID).returns([@reporting_entity])
    electric_rate = nil
    assert_difference -> { ElectricRate.count }, +1 do
      electric_rate = ElectricRate.import_aedg!(@valid_props)
    end

    assert_equal @valid_props[:year], electric_rate.year
    assert_equal @valid_props[:residential_rate], electric_rate.residential_rate
    assert_equal @reporting_entity, electric_rate.reporting_entity
  end

  test 'import_aedg! raises NotNullViolation when associated grid does not exist' do
    ReportingEntity.stubs(:from_aedg_id).with(INVALID_AEDG_ID).returns([])
    invalid_props = @valid_props.merge(reporting_entity_id: INVALID_AEDG_ID)
    assert_raises(ActiveRecord::NotNullViolation) do
      ElectricRate.import_aedg!(invalid_props)
    end
  end
end
