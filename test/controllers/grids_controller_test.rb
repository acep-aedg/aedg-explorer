require "test_helper"

class GridsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grid = grids(:one)
  end

  test "should get index" do
    get grids_url
    assert_response :success
  end

  test "should redirect grid show to general grid path" do
    get grid_url(@grid)
    assert_response :see_other
    assert_redirected_to power_generation_grid_path(@grid)
    follow_redirect!
    assert_response :success
  end
end
