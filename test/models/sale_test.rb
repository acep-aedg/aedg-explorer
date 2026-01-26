require "test_helper"

class SaleTest < ActiveSupport::TestCase
  test "scope :with_revenue_breakdown filters correctly" do
    match     = Sale.create!(default_params.merge(residential_revenue: 100))
    no_match  = Sale.create!(default_params.merge(residential_revenue: 0, commercial_revenue: 0))

    results = Sale.with_revenue_breakdown

    assert_includes results, match, "Should include record with revenue"
    assert_not_includes results, no_match, "Should exclude record with 0 revenue"
  end

  test "scope :with_revenue_breakdown works with commercial revenue" do
    match = Sale.create!(default_params.merge(residential_revenue: 0, commercial_revenue: 100))
    assert_includes Sale.with_revenue_breakdown, match
  end

  test "scope :with_sales_breakdown filters correctly" do
    residential = Sale.create!(default_params.merge(residential_sales: 50, commercial_sales: 50))
    commercial  = Sale.create!(default_params.merge(residential_sales: 0, commercial_sales: 50))
    none        = Sale.create!(default_params.merge(residential_sales: 0, commercial_sales: 0))

    results = Sale.with_sales_breakdown

    assert_includes results, residential
    assert_includes results, commercial
    assert_not_includes results, none
  end

  test "scope :with_customers_breakdown filters correctly" do
    residential = Sale.create!(default_params.merge(residential_customers: 10, commercial_customers: 0))
    commercial  = Sale.create!(default_params.merge(residential_customers: 0, commercial_customers: 10))
    none        = Sale.create!(default_params.merge(residential_customers: 0, commercial_customers: 0))

    results = Sale.with_customers_breakdown

    assert_includes results, residential
    assert_includes results, commercial
    assert_not_includes results, none
  end

  test "scope :with_sales includes records with only total_sales" do
    total_only = Sale.create!(default_params.merge(total_sales: 500))

    assert_includes Sale.with_sales, total_only
    assert_not_includes Sale.with_sales_breakdown, total_only
  end

  test "scope :with_sales includes records with breakdown data" do
    part_only = Sale.create!(default_params.merge(residential_sales: 100))
    assert_includes Sale.with_sales, part_only
  end

  test "scope :with_sales excludes records with no sales data" do
    no_sales = Sale.create!(default_params.merge(total_sales: 0, residential_sales: 0, commercial_sales: 0))
    assert_not_includes Sale.with_sales, no_sales
  end

  test "scope :with_any_breakdown_data combines all filters" do
    # 1. Has Revenue only
    s1 = Sale.create!(default_params.merge(residential_revenue: 100, residential_sales: 0, residential_customers: 0))

    # 2. Has Sales only
    s2 = Sale.create!(default_params.merge(residential_revenue: 0, residential_sales: 100, residential_customers: 0))

    # 3. Has Customers only
    s3 = Sale.create!(default_params.merge(residential_revenue: 0, residential_sales: 0, residential_customers: 5))

    # 4. Has Nothing (The Control Group)
    s4 = Sale.create!(default_params.merge(residential_revenue: 0, residential_sales: 0, residential_customers: 0))

    results = Sale.with_any_breakdown_data

    assert_includes results, s1
    assert_includes results, s2
    assert_includes results, s3
    assert_not_includes results, s4
  end

  private

  def default_params
    {
      reporting_entity: reporting_entities(:one),
      year: 2020,
      residential_revenue: 0, commercial_revenue: 0,
      residential_sales: 0,   commercial_sales: 0,
      residential_customers: 0, commercial_customers: 0
    }
  end
end
