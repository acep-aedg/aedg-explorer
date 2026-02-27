require "test_helper"

class ReportingEntityAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEDG_ID, name: "Test Grid")
    @valid_props = {
      id: VALID_AEDG_ID,
      name: "Test Utility",
      most_recent_year: 2021,
      grid_id: VALID_AEDG_ID
    }
  end
  test "build_from_aedg builds a reporting entity in memory with valid props" do
    reporting_entity = ReportingEntity.build_from_aedg(@valid_props)

    assert_instance_of ReportingEntity, reporting_entity
    assert reporting_entity.new_record?

    assert_equal @valid_props[:name], reporting_entity.name
    assert_equal @valid_props[:id], reporting_entity.aedg_import.aedg_id
    assert_equal @grid, reporting_entity.grid
  end

  test "build_from_aedg raises RuntimeError when id is missing" do
    invalid_props = @valid_props.merge(id: nil)
    exception = assert_raises(RuntimeError) do
      ReportingEntity.build_from_aedg(invalid_props)
    end

    assert_equal "id is required", exception.message
  end

  test "is invalid when associated grid does not exist" do
    invalid_props = @valid_props.merge(grid_id: INVALID_AEDG_ID)
    reporting_entity = ReportingEntity.build_from_aedg(invalid_props)

    assert_not reporting_entity.valid?
    assert_includes reporting_entity.errors[:grid], "must exist"
  end
end
