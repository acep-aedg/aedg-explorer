require 'test_helper'

class Communities::ChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community = communities(:one)
    @grid = @community.grid
  end

  test 'should get production_monthly' do
    get production_monthly_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    generation = @grid.monthly_generations.first
    month_abbr = Date::ABBR_MONTHNAMES[generation.month]
    assert_equal generation.year.to_s, body.first['name']
    assert_equal generation.net_generation_mwh.to_s, body.first['data'][month_abbr]
  end

  test 'should get production_yearly' do
    get production_yearly_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    label, value = body.first
    generation = @grid.yearly_generations.first
    assert_includes label, generation.fuel_type_code
    assert_includes label, generation.fuel_type_name
    assert_equal generation.net_generation_mwh, value
  end

  test 'should get capacity_yearly' do
    get capacity_yearly_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    label, value = body.first
    capacity = @grid.capacities.first
    assert_includes label, capacity.fuel_type_code
    assert_includes label, capacity.fuel_type_name
    assert_equal capacity.capacity_mw, value
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
  test 'should get average_sales_rates' do
    get average_sales_rates_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    sale = @community.reporting_entity.sales.order(year: :asc).first
    assert_equal sale.year.to_s, body.first['name']
    assert_equal sale.residential_rate, body.first['data']['Residential']
    assert_equal sale.commercial_rate, body.first['data']['Commercial']
    assert_equal sale.total_rate, body.first['data']['Total']
  end

  test 'should get revenue_by_customer_type when sale exists' do
    get revenue_by_customer_type_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    sale = @community.reporting_entity.latest_sale
    assert sale, 'Expected a sale to exist for this community'
    assert_equal sale.residential_revenue, body['Residential']
    assert_equal sale.commercial_revenue, body['Commercial']
  end

  test 'should return empty revenue_by_customer_type json when no sale exists' do
    reporting_entity = @community.reporting_entity
    reporting_entity.sales.destroy_all
    get revenue_by_customer_type_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    assert_equal({}, body)
  end

  test 'should get customers_by_customer_type' do
    get customers_by_customer_type_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    sale = @community.reporting_entity.latest_sale
    assert_equal sale.residential_customers, body['Residential']
    assert_equal sale.commercial_customers, body['Commercial']
  end

  test 'should return empty customers_by_customer_type json when no sale exists' do
    reporting_entity = @community.reporting_entity
    reporting_entity.sales.destroy_all
    get customers_by_customer_type_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    assert_equal({}, body)
  end

  test 'should get sales_by_customer_type' do
    get sales_by_customer_type_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    sale = @community.reporting_entity.latest_sale
    assert_equal sale.residential_sales, body['Residential']
    assert_equal sale.commercial_sales, body['Commercial']
  end

  test 'should return empty sales_by_customer_type json when no sale exists' do
    reporting_entity = @community.reporting_entity
    reporting_entity.sales.destroy_all
    get sales_by_customer_type_community_charts_url(@community)
    assert_response :success
    assert_equal 'application/json', @response.media_type
    body = JSON.parse(@response.body)
    assert_equal({}, body)
  end
end
