require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  setup do
    @sale = sales(:one)
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
