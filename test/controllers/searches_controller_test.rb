require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get advanced search" do
    get search_advanced_url
    assert_response :success
  end
end
