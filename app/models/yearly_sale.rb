class YearlySale < ApplicationRecord
  include YearlySaleAttributes

  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity
  validates :year, presence: true
  validates :reporting_entity_id,
            uniqueness: { scope: %i[year],
                          message: "combination of reporting_entity_id & year" }
  default_scope { order(year: :desc) }

  scope :latest, -> { where(year: select(:year).order(year: :desc).limit(1)) }
  scope :for_owner, ->(owner) { owner ? joins(:reporting_entity).merge(owner.reporting_entities) : all }

  scope :with_sales, -> { where(sales_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :with_totals, -> { where(total_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :with_revenue, -> { where(revenue_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :with_customers, -> { where(customer_fields.map { |f| "#{f} IS NOT NULL" }.join(" OR ")) }
  scope :valid_for_usage_per_customer, -> { with_sales.with_customers }

  def self.sectors
    %i[residential commercial industrial transportation community government unbilled other]
  end

  def self.categories
    %i[sales revenue customers]
  end

  def self.sales_fields
    %i[residential_sales commercial_sales industrial_sales transportation_sales community_sales government_sales unbilled_sales other_sales]
  end

  def self.revenue_fields
    %i[residential_revenue commercial_revenue industrial_revenue transportation_revenue community_revenue government_revenue unbilled_revenue other_revenue]
  end

  def self.customer_fields
    %i[residential_customers commercial_customers industrial_customers transportation_customers community_customers government_customers unbilled_customers other_customers]
  end

  def self.total_fields
    %i[total_revenue total_sales total_customers]
  end

  def self.available_years_for(owner)
    for_owner(owner).where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.usage_per_customer_rates
    records_by_year = valid_for_usage_per_customer.reorder(year: :asc).group_by(&:year)

    records_by_year.map do |year, records|
      sectors.each_with_object({ year: year }) do |sector, year_data|
        year_data[sector] = usage_per_customer(records, sector)
      end
    end
  end

  def self.usage_per_customer(records, sector)
    sales     = records.sum { |r| r.send("#{sector}_sales").to_f }
    customers = records.sum { |r| r.send("#{sector}_customers").to_f }

    return nil unless customers.positive? && sales.positive?

    (sales / customers).round(2)
  end
end
