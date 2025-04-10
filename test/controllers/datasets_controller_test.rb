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

  test "should download dataset csv" do
    get download_metadatum_dataset_url(@metadatum, @dataset, format: @dataset.format.downcase)
    assert_response :success
  end

  test "should download dataset geojson" do
    @dataset = datasets(:geojson_dataset)
    get download_metadatum_dataset_url(@metadatum, @dataset, format: @dataset.format.downcase)
    assert_response :success
  end
end