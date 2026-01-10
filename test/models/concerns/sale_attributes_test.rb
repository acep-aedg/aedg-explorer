require 'test_helper'

class SaleAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = grids(:one)
    @reporting_entity = ReportingEntity.create!(aedg_id: VALID_AEDG_ID, name: 'Test Utility', most_recent_year: 2021, grid: @grid)
    @valid_props = {
      reporting_entity_id: VALID_AEDG_ID,
      year: 2021,
      residential_revenue: 100_000,
      commercial_sales: 8000,
      total_customers: 2500
    }
  end

  test 'import_aedg! creates sale record with valid props' do
    sale = nil
    assert_difference -> { Sale.count }, 1 do
      sale = Sale.import_aedg!(@valid_props)
    end

    assert_equal @reporting_entity, sale.reporting_entity
    assert_equal @valid_props[:year], sale.year
    assert_equal @valid_props[:residential_revenue], sale.residential_revenue
    assert_equal @valid_props[:commercial_sales], sale.commercial_sales
    assert_equal @valid_props[:total_customers], sale.total_customers
  end

  test 'import_aedg! raises RecordInvalid if reporting_entity is not found' do
    invalid_props = @valid_props.merge(reporting_entity_id: INVALID_AEDG_ID)

    assert_raises ActiveRecord::RecordInvalid do
      Sale.import_aedg!(invalid_props)
    end
  end
end
