require "test_helper"

class MetadataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get metadata_url
    assert_response :success
  end

  test "should get show" do
    @metadatum = metadata(:one)
    get metadatum_url(@metadatum)
    assert_response :success
  end

  test "should get search" do
    get search_metadata_url
    assert_response :success
  end

end
