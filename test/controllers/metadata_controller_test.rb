require "test_helper"

class MetadataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metadatum = oemetadata(:one)
  end

  test "should get index" do
    get metadata_url
    assert_response :success
  end

  test "should get show" do
    get metadatum_url(@metadatum)
    assert_response :success
  end

  test "should get search" do
    get search_metadata_url
    assert_response :success
  end

  test "should download metadatum" do
    get download_metadatum_url(@metadatum)
    assert_response :success
  end
end
