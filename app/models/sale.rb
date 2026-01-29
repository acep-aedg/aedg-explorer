class Sale < ApplicationRecord
  include SaleAttributes

  belongs_to :reporting_entity, touch: true
  has_many :communities, through: :reporting_entity
  validates :year, presence: true

  scope :latest, -> { where(year: select(:year).order(year: :desc).limit(1)) }
  scope :for_owner, ->(owner) { owner ? joins(:reporting_entity).merge(owner.reporting_entities) : all }

  # BREAKDOWN SCOPES (For Pie Charts / Stacked Bars)
  # These ensure we have the specific parts needed for detailed charts.
  scope :with_revenue_breakdown,   -> { where("residential_revenue > 0 OR commercial_revenue > 0") }
  scope :with_sales_breakdown,     -> { where("residential_sales > 0 OR commercial_sales > 0") }
  scope :with_customers_breakdown, -> { where("residential_customers > 0 OR commercial_customers > 0") }

  # GENERAL SCOPES (For "Do we have data?" checks)
  # These check if we have ANY data at all, including the aggregate 'total' columns.
  scope :with_sales, -> { where("total_sales > 0 OR residential_sales > 0 OR commercial_sales > 0") }

  # COMBINED SCOPES (For "Do we have data?" checks)
  # "Do we have enough data for the Breakdown Tab?"
  scope :with_any_breakdown_data, -> { with_revenue_breakdown.or(with_sales_breakdown).or(with_customers_breakdown) }

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
end
