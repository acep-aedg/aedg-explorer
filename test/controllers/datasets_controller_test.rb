require "test_helper"

class DatasetsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get datasets_url
    assert_response :success
  end

  test "should show dataset" do
    @metadatum = metadata(:one)
    get metadatum_dataset_url
    assert_response :success
  end
end
