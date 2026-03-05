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

  def self.latest_summary_for(sales_relation)
    # 1. Find the max year within the passed list
    latest_year = sales_relation.maximum(:year)
    return nil unless latest_year

    # 2. Filter the list to just that year
    records = sales_relation.where(year: latest_year).includes(:reporting_entity)

    # 3. Return the calculated summary
    OpenStruct.new( # rubocop:disable Style/OpenStructUse
      year: latest_year,
      total_sales: records.sum(:total_sales),
      total_revenue: records.sum(:total_revenue),
      total_customers: records.sum(:total_customers),
      reporter_names: records.map { |s| s.reporting_entity.name }.uniq.to_sentence
    )
  end

  def format_yearly_value(value, category)
    return "-" if value.blank? || value.zero?

    case category.to_sym
    when :revenue
      number_to_currency(value, precision: 0)
    when :customers
      number_with_delimiter(value.to_i)
    else # :sales
      "#{number_with_delimiter(value)} MWh"
    end
  end
end
