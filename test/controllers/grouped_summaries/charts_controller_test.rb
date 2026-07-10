require "test_helper"

module GroupedSummaries
  class ChartsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @borough = boroughs(:one)
    end

    test "grouped summaries with communities with the same reporting entity are not being duplicated (tested via Borough subclass)" do
      get electricity_revenue_borough_charts_url(@borough)

      assert_response :success

      json_response = response.parsed_body

      assert_includes json_response.keys, "labels", "JSON should contain a labels array for chart years"
      assert_includes json_response.keys, "datasets", "JSON should contain a datasets array for categories"
      assert_includes json_response["labels"], "2020", "Labels should include the year 2020 from fixture"

      # Test residential values
      res_dataset = json_response["datasets"].first
      assert_not_nil res_dataset, "Datasets should not be empty"
      assert_includes res_dataset.keys, "label"
      assert_includes res_dataset.keys, "data"

      # Test residential values
      assert_includes res_dataset["data"], 3000.0, "Should sum residential_revenue values from reporting_entities one & three without duplicating values from one"
    end
  end
end
