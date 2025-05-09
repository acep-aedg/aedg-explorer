require 'test_helper'

class SaleAttributesTest < ActiveSupport::TestCase
  setup do
    @grid = grids(:one)
    @reporting_entity = ReportingEntity.create!(
      aedg_id: 101,
      name: 'Test Utility',
      year: 2021,
      grid: @grid
    )
  end

  test 'import_aedg! creates a sale with correct attributes using stubbed reporting_entity' do
    ReportingEntity.stubs(:from_aedg_id).with(101).returns([@reporting_entity])

    attributes = {
      reporting_entity_id: 101,
      year: 2021,
      residential_revenue: 100_000,
      residential_sales: 5_000,
      residential_customers: 1000,
      commercial_revenue: 200_000,
      commercial_sales: 8000,
      commercial_customers: 1500,
      total_revenue: 300_000,
      total_sales: 13_000,
      total_customers: 2500
    }

    assert_difference -> { Sale.count }, 1 do
      sale = Sale.import_aedg!(attributes)

      assert_equal @reporting_entity, sale.reporting_entity
      assert_equal 2021, sale.year
      assert_equal 100_000, sale.residential_revenue
      assert_equal 13_000, sale.total_sales
      assert_equal 2500, sale.total_customers
    end
  end

  test 'import_aedg! raises if reporting_entity is not found' do
    ReportingEntity.stubs(:from_aedg_id).with(999).returns([])

    assert_raises ActiveRecord::RecordInvalid do
      Sale.import_aedg!({
                          reporting_entity_id: 999,
                          year: 2022,
                          residential_revenue: 100,
                          residential_sales: 100,
                          residential_customers: 10,
                          commercial_revenue: 100,
                          commercial_sales: 100,
                          commercial_customers: 10,
                          total_revenue: 200,
                          total_sales: 200,
                          total_customers: 20
                        })
    end
  end
end
