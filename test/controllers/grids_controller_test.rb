require 'test_helper'

class GridsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grid = grids(:one)
  end

  test 'should get index' do
    get grids_url
    assert_response :success
  end

  test 'should get show' do
    get grid_url(@grid)
    assert_response :success
  end
end
