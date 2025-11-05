class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  include Charts
  before_action :set_community
  before_action :set_latest_sale, only: %i[revenue_by_customer_type customers_by_customer_type sales_by_customer_type]

  def production_monthly
    render json: production_monthly_for(@community)
  end

  def production_yearly
    render json: production_yearly_for(@community, params[:year].presence&.to_i)
  end

  def capacity_yearly
    render json: capacity_yearly_for(@community, params[:year].presence&.to_i)
  end

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

  def bulk_fuel_capacity_mix
    @capacity_mix = @community.bulk_fuel_facilities.capacity_by_fuel_type
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end

  def set_latest_sale
    @latest_sale = @community.reporting_entity&.latest_sale
  end

  def customer_type_chart(name, residential_attr, commercial_attr)
    return {} unless @latest_sale

    Rails.cache.fetch(['charts', @community.cache_key_with_version, @latest_sale.cache_key_with_version, name], expires_in: 12.hours) do
      {
        'Residential' => @latest_sale.public_send(residential_attr),
        'Commercial' => @latest_sale.public_send(commercial_attr)
      }
    end
  end
end
