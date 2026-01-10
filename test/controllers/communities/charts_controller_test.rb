require 'test_helper'

class Communities::ChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community = communities(:one)
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

  # test 'should get energy_sold' do
  #   get energy_sold_community_charts_url(@community)
  #   assert_response :success
  #   assert_equal 'application/json', @response.media_type
  #   body = JSON.parse(@response.body)
  #   sale = @community.reporting_entity.sales.order(year: :asc).first

  #   residential_series = body.find { |s| s['name'] == 'Residential' }
  #   assert_equal sale.residential_sales, residential_series['data'][sale.year.to_s]
  #   commercial_series = body.find { |s| s['name'] == 'Commercial' }
  #   assert_equal sale.commercial_sales, commercial_series['data'][sale.year.to_s]
  #   # total_series = body.find { |s| s['name'] == 'Total' }
  #   # assert_equal sale.total_sales, total_series['data'][sale.year.to_s]
  # end

  # test 'should get customer_breakdown_revenue' do
  #   get customer_breakdown_revenue_community_charts_path(@community)
  #   assert_response :success
  #   assert_equal 'application/json', @response.media_type
  #   body = JSON.parse(@response.body)
  #   sale = @community.reporting_entity.latest_sale
  #   assert sale, 'Expected a sale to exist for this community'
  #   assert_equal sale.residential_revenue, body['Residential']
  #   assert_equal sale.commercial_revenue, body['Commercial']
  # end

  # test 'should get customer_breakdown_customers' do
  #   get customer_breakdown_customers_community_charts_path(@community)
  #   assert_response :success
  #   assert_equal 'application/json', @response.media_type
  #   body = JSON.parse(@response.body)
  #   sale = @community.reporting_entity.latest_sale
  #   assert_equal sale.residential_customers, body['Residential']
  #   assert_equal sale.commercial_customers, body['Commercial']
  # end

  # test 'should get customer_breakdown_sales' do
  #   get customer_breakdown_sales_community_charts_path(@community)
  #   assert_response :success
  #   assert_equal 'application/json', @response.media_type
  #   body = JSON.parse(@response.body)
  #   sale = @community.reporting_entity.latest_sale
  #   assert_equal sale.residential_sales, body['Residential']
  #   assert_equal sale.commercial_sales, body['Commercial']
  # end
end
