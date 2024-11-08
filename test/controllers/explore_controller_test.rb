require "test_helper"

class ExploreControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get explore_home_url
    assert_response :success
  end

  test "should get communities" do
    get explore_communities_url
    assert_response :success
  end
end
