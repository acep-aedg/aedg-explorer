class Sale < ApplicationRecord
  include SaleAttributes
  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity
  validates :year, presence: true
  validates :reporting_entity_id, presence: true
  
  scope :latest, -> { where(year: select(:year).order(year: :desc).limit(1)) }
  scope :for_owner, ->(owner) { owner ? joins(:reporting_entity).merge(owner.reporting_entities) : all }

  def self.available_years_for(owner)
    for_owner(owner).where.not(year: nil).distinct.order(year: :desc).pluck(:year)
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

  def calculate_kwh_rate(revenue, sales_mwh)
    return nil if sales_mwh.to_f.zero?

    # Revenue / (Sales MWh * 1000 to get kWh)
    revenue.to_f / (sales_mwh * 1000)
  end

  def self.latest_summary_for(sales_relation)
    # 1. Find the max year within the passed list
    latest_year = sales_relation.maximum(:year)
    return nil unless latest_year

    # 2. Filter the list to just that year
    records = sales_relation.where(year: latest_year).includes(:reporting_entity)

    # 3. Return the calculated summary
    OpenStruct.new(
      year: latest_year,
      total_sales: records.sum(:total_sales),
      total_revenue: records.sum(:total_revenue),
      total_customers: records.sum(:total_customers),
      reporter_names: records.map { |s| s.reporting_entity.name }.uniq.to_sentence
    )
  end
end
