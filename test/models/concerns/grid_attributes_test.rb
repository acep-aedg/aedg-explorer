require 'test_helper'

class GridAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @valid_props = {
      id: VALID_AEDG_ID,
      name: 'Test Grid'
    }
  end

  test 'import_aedg! creates a grid with valid props' do
    grid = nil
    assert_difference -> { Grid.count }, +1 do
      grid = Grid.import_aedg!(@valid_props)
    end
    assert_equal @valid_props[:name], grid.name
    assert_equal @valid_props[:id], grid.aedg_id
  end

  test 'import_aedg! raises error if id is missing' do
    invalid_props = @valid_props.except(:id)
    assert_raises(RuntimeError, 'id is required') do
      Grid.import_aedg!(invalid_props)
    end
  end
  test 'import_aedg! raises error if grid already exists' do
    Grid.create!(aedg_id: VALID_AEDG_ID, name: 'Existing Grid')

    assert_raises ActiveRecord::RecordInvalid do
      Grid.import_aedg!(@valid_props)
    end
  end
end
