class Sale < ApplicationRecord
  include SaleAttributes
  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity

  validates :year, presence: true

  def residential_rate
    return nil if residential_sales.to_f.zero?

    residential_revenue.to_f / residential_sales
  end

  def commercial_rate
    return nil if commercial_sales.to_f.zero?

    commercial_revenue.to_f / commercial_sales
  end

  def total_rate
    return nil if total_sales.to_f.zero?

    total_revenue.to_f / total_sales
  end

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
end
