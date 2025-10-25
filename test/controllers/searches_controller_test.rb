require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get searches_show_url
    assert_response :success
  end

  test "should get advanced" do
    get searches_advanced_url
    assert_response :success
  end
end
