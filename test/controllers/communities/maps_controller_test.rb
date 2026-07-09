require "test_helper"

module Communities
  class MapsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @community = communities(:one)
    end

    test "should get house_districts" do
      get house_districts_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end

    test "should get senate_districts" do
      get senate_districts_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end

    test "should get service_area_geom" do
      get service_area_geom_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end

    test "should get service_area" do
      get service_area_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end

    test "should get plants" do
      get plants_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end

    test "should get bulk_fuel_facilities" do
      get bulk_fuel_facilities_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end

    test "should get boroughs" do
      get boroughs_community_maps_url(@community)
      assert_response :success
      assert_equal "application/geo+json", @response.media_type
    end
  end
end
