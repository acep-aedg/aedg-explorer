class Sale < ApplicationRecord
  include SaleAttributes
  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity
  validates :year, presence: true

  def any_customer_type_data?
    [
      residential_customers,
      commercial_customers,
      residential_sales,
      commercial_sales,
      residential_revenue,
      commercial_revenue
    ].any?(&:present?)
  end

  def calculate_kwh_rate(revenue, sales_mwh)
    return nil if sales_mwh.to_f.zero?

    # Revenue / (Sales MWh * 1000 to get kWh)
    revenue.to_f / (sales_mwh * 1000)
  end
end
