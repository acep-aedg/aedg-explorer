class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  before_action :set_community
  before_action :set_latest_sale, only: %i[revenue_by_customer_type customers_by_customer_type sales_by_customer_type]
  before_action :set_year, only: %i[production_yearly capacity_yearly]

  def production_monthly; end
  def production_yearly; end
  def capacity_yearly; end

  def population_employment
    employments = @community.employments.sort_by(&:measurement_year)
    chart_data = Rails.cache.fetch(['charts', @community.cache_key_with_version, 'population_employment'], expires_in: 12.hours) do
      employment_chart_data(employments)
    end

    render json: chart_data
  end

  def average_sales_rates
    sales = @community.reporting_entity.sales.order(year: :asc)
    chart_data = Rails.cache.fetch(['charts', @community.cache_key_with_version, sales.cache_key_with_version, 'average_sales_rates'], expires_in: 12.hours) do
      sales.map do |sale|
        values = {
          'Residential' => sale.residential_rate,
          'Commercial' => sale.commercial_rate,
          'Total' => sale.total_rate
        }.transform_values { |v| v&.to_f&.round(2) }

        { name: sale.year.to_s, data: values }
      end
    end

    render json: chart_data
  end

  def revenue_by_customer_type; end
  def customers_by_customer_type; end
  def sales_by_customer_type; end
  def bulk_fuel_capacity_mix; end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end

  def set_latest_sale
    @latest_sale = @community.reporting_entity&.latest_sale
  end

  def set_year
    @year = params[:year].presence&.to_i
  end
end
