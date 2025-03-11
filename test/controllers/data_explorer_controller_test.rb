require "test_helper"

class DataExplorerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get data_explorer_index_url
    assert_response :success
  end
end
