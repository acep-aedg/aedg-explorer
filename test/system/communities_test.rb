require "application_system_test_case"

class CommunitiesTest < ApplicationSystemTestCase
  setup do
    @community = communities(:one)
  end

  test "visiting the index" do
    visit communities_url
    assert_selector "h1", text: "Communities"
  end

  test "should create community" do
    visit communities_url
    click_on "New community"

    fill_in "Global uuid", with: @community.global_uuid
    fill_in "Id", with: @community.id
    fill_in "Incorporation", with: @community.incorporation
    fill_in "Incorporation", with: @community.incorporation_id
    fill_in "Latitude", with: @community.latitude
    fill_in "Longitude", with: @community.longitude
    fill_in "Name", with: @community.name
    click_on "Create Community"

    assert_text "Community was successfully created"
    click_on "Back"
  end

  test "should update Community" do
    visit community_url(@community)
    click_on "Edit this community", match: :first

    fill_in "Global uuid", with: @community.global_uuid
    fill_in "Id", with: @community.id
    fill_in "Incorporation", with: @community.incorporation
    fill_in "Incorporation", with: @community.incorporation_id
    fill_in "Latitude", with: @community.latitude
    fill_in "Longitude", with: @community.longitude
    fill_in "Name", with: @community.name
    click_on "Update Community"

    assert_text "Community was successfully updated"
    click_on "Back"
  end

  test "should destroy Community" do
    visit community_url(@community)
    click_on "Destroy this community", match: :first

    assert_text "Community was successfully destroyed"
  end
end
