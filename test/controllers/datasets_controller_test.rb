require "test_helper"

class DatasetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dataset = datasets(:one)
  end

  test "should get index" do
    get datasets_url
    assert_response :success
  end

  test "should show dataset" do
    get dataset_url(@dataset)
    assert_response :success
  end
end
