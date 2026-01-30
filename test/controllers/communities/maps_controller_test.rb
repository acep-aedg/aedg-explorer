require "test_helper"

module Communities
  class MapsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @community = communities(:one)
    end

    test "should get house_districts" do
      get house_districts_community_maps_url(@community)
      assert_response :success
      assert_equal "application/json", @response.media_type
    end

    test "should get senate_districts" do
      get senate_districts_community_maps_url(@community)
      assert_response :success
      assert_equal "application/json", @response.media_type
    end
  end
end
