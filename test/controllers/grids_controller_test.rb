require "test_helper"

class GridsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grids_index_url
    assert_response :success
  end

  test "should get show" do
    get grids_show_url
    assert_response :success
  end
end
