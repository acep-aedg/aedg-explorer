require 'test_helper'

class ReportingEntityAttributesTest < ActiveSupport::TestCase
  test 'import_aedg! creates a reporting entity with correct attributes using stubbed grid' do
    fake_grid = Grid.new(aedg_id: 1, name: 'Stub Grid')
    Grid.stubs(:from_aedg_id).with(1).returns([fake_grid])

    assert_difference -> { ReportingEntity.count }, +1 do
      reporting_entity = ReportingEntity.import_aedg!({
                                                        'id' => 1,
                                                        'name' => 'Mocked Utility',
                                                        'year' => 2020,
                                                        'grid_id' => 1
                                                      })

      assert_equal 'Mocked Utility', reporting_entity.name
      assert_equal 1, reporting_entity.aedg_id
      assert_equal 2020, reporting_entity.year
      assert_equal fake_grid, reporting_entity.grid
    end
  end

  test 'import_aedg! raises error if id is missing' do
    assert_raises(RuntimeError, 'id is required') do
      ReportingEntity.import_aedg!({
                                     'name' => 'Missing ID Utility',
                                     'year' => 2021,
                                     'grid_id' => 1
                                   })
    end
  end

  test 'import_aedg! raises validation error if grid is not found' do
    Grid.stubs(:from_aedg_id).with(999).returns([])
    assert_raises(ActiveRecord::RecordInvalid) do
      ReportingEntity.import_aedg!({
                                     'id' => 2,
                                     'name' => 'No Grid Utility',
                                     'year' => 2022,
                                     'grid_id' => 999
                                   })
    end
  end
end
