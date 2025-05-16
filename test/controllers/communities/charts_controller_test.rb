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
end
