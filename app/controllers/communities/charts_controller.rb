class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  include Charts
  before_action :set_community

  def production_monthly
    production_monthly_for(@community)
  end

  def production_yearly
    production_yearly_for(@community)
  end

  def capacity_yearly
    capacity_yearly_for(@community)
  end

  def population_employment
    employments = @community.employments.sort_by(&:measurement_year)
    render json: employment_chart_data(employments)
  end

  def average_sales_rates
    sales = @community.reporting_entity.sales.order(year: :asc)
    dataset = sales.map do |sale|
      values = {
        'Residential' => sale.residential_rate,
        'Commercial' => sale.commercial_rate,
        'Total' => sale.total_rate
      }.transform_values { |v| v&.to_f&.round(2) }

      { name: sale.year.to_s, data: values }
    end

    render json: dataset
  end

  def revenue_by_customer_type
    sale = @community.reporting_entity.latest_sale
    return render json: {} unless sale

    render json: {
      'Residential' => sale.residential_revenue,
      'Commercial' => sale.commercial_revenue
    }
  end

  def customers_by_customer_type
    sale = @community.reporting_entity.latest_sale
    return render json: {} unless sale

    render json: {
      'Residential' => sale.residential_customers,
      'Commercial' => sale.commercial_customers
    }
  end

  def sales_by_customer_type
    sale = @community.reporting_entity.latest_sale
    return render json: {} unless sale

    render json: {
      'Residential' => sale.residential_sales,
      'Commercial' => sale.commercial_sales
    }
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end
end
