require "test_helper"

class BoroughsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get boroughs_index_url
    assert_response :success
  end
end
