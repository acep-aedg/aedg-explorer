require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_url
    assert_response :success
  end

  test 'should get about' do
    get about_url
    assert_response :success
  end

  test 'should get user_guide' do
    get user_guide_url
    assert_response :success
  end
end
