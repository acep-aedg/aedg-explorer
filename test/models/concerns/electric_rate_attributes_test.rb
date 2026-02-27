require "test_helper"

class ElectricRateAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = grids(:one)
    @reporting_entity = ReportingEntity.create!(aedg_id: VALID_AEDG_ID, name: "Test Utility", most_recent_year: 2021, grid: @grid)
    @valid_props = {
      reporting_entity_id: VALID_AEDG_ID,
      year: 2021,
      residential_rate: 0.2
    }
  end

  test "build_from_aedg prepares an electric rate in memory with valid props" do
    electric_rate = ElectricRate.build_from_aedg(@valid_props)

    assert_instance_of ElectricRate, electric_rate
    assert electric_rate.new_record?
    assert electric_rate.valid?, "Should be valid: #{electric_rate.errors.full_messages}"

    assert_equal @valid_props[:year], electric_rate.year
    assert_equal @valid_props[:residential_rate], electric_rate.residential_rate
    assert_equal @reporting_entity, electric_rate.reporting_entity
  end

  test "is invalid when associated reporting entity does not exist" do
    invalid_props = @valid_props.merge(reporting_entity_id: INVALID_AEDG_ID)
    electric_rate = ElectricRate.build_from_aedg(invalid_props)

    assert_not electric_rate.valid?
    assert_includes electric_rate.errors[:reporting_entity], "must exist"
  end
end
