require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  setup do
    @sale = sales(:one)
  end

  test 'residential_rate returns correct value' do
    expected = @sale.residential_revenue / @sale.residential_sales
    assert_equal expected, @sale.residential_rate
  end

  test 'residential_rate returns nil when residential_sales is zero' do
    @sale.residential_sales = 0
    assert_nil @sale.residential_rate
  end

  test 'commercial_rate returns correct value' do
    expected = @sale.commercial_revenue / @sale.commercial_sales
    assert_equal expected, @sale.commercial_rate
  end

  test 'commercial_rate returns nil when commercial_sales is zero' do
    @sale.commercial_sales = 0
    assert_nil @sale.commercial_rate
  end

  test 'total_rate returns correct value' do
    expected = @sale.total_revenue / @sale.total_sales
    assert_equal expected, @sale.total_rate
  end

  test 'total_rate returns nil when total_sales is zero' do
    @sale.total_sales = 0
    assert_nil @sale.total_rate
  end

  test 'any_customer_type_data? returns true when any data present' do
    assert @sale.any_customer_type_data?
  end

  test 'any_customer_type_data? returns false when all values are nil' do
    @sale.assign_attributes(
      residential_customers: nil,
      commercial_customers: nil,
      residential_sales: nil,
      commercial_sales: nil,
      residential_revenue: nil,
      commercial_revenue: nil
    )
    assert_not @sale.any_customer_type_data?
  end
end
