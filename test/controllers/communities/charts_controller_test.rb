require "test_helper"

class Communities::ChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community = communities(:one)
    @sales_year = @community.sales.maximum(:year)
  end

  test "should get generation_monthly" do
    get generation_monthly_community_charts_url(@community, year: @community.monthly_generations.first.year)
    assert_response :success
    assert_equal "application/json", @response.media_type
    body = JSON.parse(@response.body)
    generation = @community.monthly_generations.first
    month_abbr = Date::ABBR_MONTHNAMES[generation.month]
    assert_equal "Generation (MWh)", body.first["name"]
    assert_equal generation.generation_mwh.to_s, body.first["data"][month_abbr]
  end

  test "should get generation_yearly" do
    generation = @community.yearly_generations.first
    expected_series_name = "#{generation.fuel_type_name} (#{generation.fuel_type_code})"
    get generation_yearly_community_charts_url(@community)

    assert_response :success
    assert_equal "application/json", @response.media_type

    body = JSON.parse(@response.body)

    assert_kind_of Array, body, "Expected root to be an Array of series"
    assert_not_empty body

    series = body.find { |s| s["name"] == expected_series_name }
    assert_not_nil series, "Could not find series with name: #{expected_series_name}"

    assert series.key?("color"), "Expected series to include 'color'"
    assert series.key?("data"), "Expected series to include 'data'"

    # Verify the custom RGBA color helper worked
    assert_match(/^rgba\(.*, .*\)$/, series["color"])
    actual_amount = series["data"][generation.year.to_s]

    assert_not_nil actual_amount, "Expected data for year #{generation.year}"
    assert_in_delta generation.generation_mwh.to_f, actual_amount.to_f, 0.01
  end

  test "should get capacity_yearly for a specific year" do
    year = @community.capacities.first.year
    get capacity_yearly_community_charts_url(@community, year: year)
    assert_response :success
    assert_equal "application/json", @response.media_type

    body = JSON.parse(@response.body)
    assert_equal year, body["year"], "Expected response for year #{year}"
    assert body.key?("data"), "Expected response to include 'data' key"
    assert_kind_of Array, body["data"], "Expected 'data' to be an array"

    # Check one row
    label, value = body["data"].first
    capacity = @community.capacities.find_by(year: year)
    assert_not_nil capacity, "Expected capacity for year #{year}"

    assert_includes label, capacity.fuel_type_code
    assert_includes label, capacity.fuel_type_name
    assert_in_delta capacity.capacity_mw.to_f, value.to_f, 1e-6
  end

  test "should get population_employment" do
    get population_employment_community_charts_url(@community)
    assert_response :success
    assert_equal "application/json", @response.media_type
    body = JSON.parse(@response.body)
    pop_employment = @community.employments.first
    assert_equal [[pop_employment.measurement_year, pop_employment.residents_employed]], body[0]["data"]
    assert_equal [[pop_employment.measurement_year, pop_employment.unemployment_insurance_claimants]], body[1]["data"]
  end
end
