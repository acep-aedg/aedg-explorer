require "test_helper"

class SaleAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = grids(:one)
    @reporting_entity = ReportingEntity.create!(aedg_id: VALID_AEDG_ID, name: "Test Utility", most_recent_year: 2021, grid: @grid)
    @valid_props = {
      reporting_entity_id: VALID_AEDG_ID,
      year: 2021,
      residential_revenue: 100_000,
      commercial_sales: 8000,
      total_customers: 2500
    }
  end

  test "build_from_aedg builds a sale record in memory with valid props" do
    sale = Sale.build_from_aedg(@valid_props)

    assert_instance_of Sale, sale
    assert sale.new_record?
    assert sale.valid?, "Sale should be valid: #{sale.errors.full_messages}"

    assert_equal @reporting_entity, sale.reporting_entity

    assert_equal @valid_props[:year], sale.year
    assert_equal @valid_props[:residential_revenue], sale.residential_revenue
    assert_equal @valid_props[:commercial_sales], sale.commercial_sales
    assert_equal @valid_props[:total_customers], sale.total_customers
  end

  test "is invalid when year is missing" do
    invalid_props = @valid_props.except(:year)
    sale = Sale.build_from_aedg(invalid_props)

    assert_not sale.valid?
    assert_includes sale.errors[:year], "can't be blank"
  end

  test "build_from_aedg results in an invalid record if reporting_entity is not found" do
    invalid_props = @valid_props.merge(reporting_entity_id: INVALID_AEDG_ID)
    sale = Sale.build_from_aedg(invalid_props)

    assert_not sale.valid?
    assert_includes sale.errors[:reporting_entity], "must exist"
  end
end
