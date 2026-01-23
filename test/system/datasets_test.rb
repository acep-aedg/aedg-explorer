require "application_system_test_case"

class DatasetsTest < ApplicationSystemTestCase
  setup do
    @dataset = datasets(:one)
  end

  test "visiting the index" do
    visit datasets_url
    assert_selector "h1", text: "Datasets"
  end
end
