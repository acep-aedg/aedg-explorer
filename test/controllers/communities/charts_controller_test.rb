require 'test_helper'

class Communities::ChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community = communities(:one)
    @sales_year = @community.sales.maximum(:year)
  end

  test 'should get production_monthly' do
    get production_monthly_community_charts_url(@community, year: @community.monthly_generations.first.year)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    generation = @community.monthly_generations.first
    month_abbr = Date::ABBR_MONTHNAMES[generation.month]
    assert_equal 'Net Generation (MWh)', body.first['name']
    assert_equal generation.net_generation_mwh.to_s, body.first['data'][month_abbr]
  end

  test 'should get production_yearly' do
    year = @community.yearly_generations.first.year
    get production_yearly_community_charts_url(@community, year: year)
    assert_response :success
    assert_equal 'application/json', @response.media_type

    body = JSON.parse(@response.body)
    assert_equal year, body['year'], "Expected response for year #{year}"
    assert body.key?('data'), "Expected response to include 'data' key"
    assert_kind_of Array, body['data'], "Expected 'data' to be an array"

    label, value = body['data'].first
    generation = @community.yearly_generations.first

    assert_includes label, generation.fuel_type_code
    assert_includes label, generation.fuel_type_name
    assert_equal generation.net_generation_mwh.to_f, value.to_f
  end

  test 'should get capacity_yearly for a specific year' do
    year = @community.capacities.first.year
    get capacity_yearly_community_charts_url(@community, year: year)
    assert_response :success
    assert_equal 'application/json', @response.media_type

    body = JSON.parse(@response.body)
    assert_equal year, body['year'], "Expected response for year #{year}"
    assert body.key?('data'), "Expected response to include 'data' key"
    assert_kind_of Array, body['data'], "Expected 'data' to be an array"

    # Check one row
    label, value = body['data'].first
    capacity = @community.capacities.find_by(year: year)
    assert_not_nil capacity, "Expected capacity for year #{year}"

    assert_includes label, capacity.fuel_type_code
    assert_includes label, capacity.fuel_type_name
    assert_in_delta capacity.capacity_mw.to_f, value.to_f, 1e-6
  end

  test 'should get population_employment' do
    get population_employment_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    pop_employment = @community.employments.first
    assert_equal [[pop_employment.measurement_year, pop_employment.residents_employed]], body[0]['data']
    assert_equal [[pop_employment.measurement_year, pop_employment.unemployment_insurance_claimants]], body[1]['data']
  end

  test 'should get energy_sold (one reporting_entity)' do
    expected_res = 400
    expected_com = 300
    expected_entity_name = 'Test Utility One'

    get energy_sold_community_charts_url(@community, year: @sales_year)
    assert_response :success

    body = JSON.parse(@response.body)

    entity_series = body.find { |series| series['name'] == expected_entity_name }
    series_data = entity_series['data']
    res_row = series_data.find { |row| row[0] == 'Residential' }
    com_row = series_data.find { |row| row[0] == 'Commercial' }

    assert_not_nil entity_series, "Could not find series for #{expected_entity_name}"
    assert_equal expected_res, res_row[1]
    assert_equal expected_com, com_row[1]
  end

  test 'should get energy_sold with multiple reporting entities' do
    expected_entity1 = 'Test Utility One'
    expected_entity2 = 'Test Utility Three'

    get energy_sold_community_charts_url(@community, year: @sales_year)
    assert_response :success

    body = JSON.parse(@response.body)
    entity_names = body.map { |series| series['name'] }

    assert_equal 2, entity_names.size, "Expected 2 entities, but got #{entity_names.size}"
    assert_includes entity_names, expected_entity1
    assert_includes entity_names, expected_entity2
  end

  test 'should get customer_breakdown_revenue' do
    expected_res = 200
    expected_com = 950

    get customer_breakdown_revenue_community_charts_path(@community, year: @sales_year)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)

    residential_row = body.find { |row| row[0] == 'Residential' }
    commercial_row = body.find { |row| row[0] == 'Commercial' }

    assert_equal expected_res, residential_row[1]
    assert_equal expected_com, commercial_row[1]
  end

  test 'should get customer_breakdown_customers' do
    expected_res = 300
    expected_com = 1700

    get customer_breakdown_customers_community_charts_path(@community, year: @sales_year)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)

    residential_row = body.find { |row| row[0] == 'Residential' }
    commercial_row = body.find { |row| row[0] == 'Commercial' }

    assert_equal expected_res, residential_row[1]
    assert_equal expected_com, commercial_row[1]
  end

  test 'should get customer_breakdown_sales' do
    expected_res = 500
    expected_com = 500

    get customer_breakdown_sales_community_charts_path(@community, year: @sales_year)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)

    residential_row = body.find { |row| row[0] == 'Residential' }
    commercial_row = body.find { |row| row[0] == 'Commercial' }

    assert_equal expected_res, residential_row[1]
    assert_equal expected_com, commercial_row[1]
  end
end
