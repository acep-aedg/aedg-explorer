class Sale < ApplicationRecord
  include SaleAttributes
  belongs_to :reporting_entity

  def residential_rate
    return nil if residential_sales.to_f.zero?

    residential_revenue / residential_sales
  end

  def commercial_rate
    return nil if commercial_sales.to_f.zero?

    commercial_revenue / commercial_sales
  end

  def total_rate
    return nil if total_sales.to_f.zero?

    total_revenue / total_sales
  end
end
