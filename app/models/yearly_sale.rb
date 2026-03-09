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
  scope :valid_for_consumption_per_customer, -> { with_sales.with_customers }

  def self.sectors
    %i[residential commercial industrial transportation community government unbilled other]
  end

  def self.sales_fields
    %i[total_sales_mwh residential_sales_mwh commercial_sales_mwh industrial_sales_mwh transportation_sales_mwh community_sales_mwh government_sales_mwh unbilled_sales_mwh other_sales_mwh]
  end

  def self.revenue_fields
    %i[residential_revenue commercial_revenue industrial_revenue transportation_revenue community_revenue other_revenue total_revenue]
  end

  def self.customer_fields
    %i[total_customers residential_customers commercial_customers industrial_customers transportation_customers community_customers government_customers unbilled_customers other_customers]
  end

  def self.total_fields
    %i[total_revenue total_sales_mwh total_customers]
  end

  def self.available_years_for(owner)
    for_owner(owner).where.not(year: nil).distinct.order(year: :desc).pluck(:year)
  end

  def self.active_fields_for(category)
    fields = case category.to_sym
             when :sales     then sales_fields
             when :revenue   then revenue_fields
             when :customers then customer_fields
             else []
             end

    active = fields.select { |field| where.not(field => nil).exists? }
    active.sort_by { |f| f.to_s.include?("total") ? 0 : 1 }
  end

  def self.consumption_per_customer(records, sector)
    sales     = records.sum { |r| r.send("#{sector}_sales_mwh").to_f }
    customers = records.sum { |r| r.send("#{sector}_customers").to_f }

    return nil unless customers.positive? && sales.positive?

    (sales / customers).round(2)
  end
end
