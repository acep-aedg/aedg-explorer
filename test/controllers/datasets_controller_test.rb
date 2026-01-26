require "test_helper"

class DatasetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metadatum = oemetadata(:one)
    @dataset = datasets(:csv_dataset)
  end

  test "should show dataset" do
    get metadatum_dataset_url(@metadatum, @dataset)
    assert_response :success
  end
end
