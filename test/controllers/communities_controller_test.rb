require "test_helper"

class CommunitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community = communities(:one)
  end

  test "should get index" do
    get communities_url
    assert_response :success
  end

  test "should redirect community show to general community path" do
    get community_url(@community)
    assert_response :see_other
    assert_redirected_to general_community_path(@community)
    follow_redirect!
    assert_response :success
  end
end
