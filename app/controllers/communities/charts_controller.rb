class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  before_action :set_community
  before_action :set_latest_sale, only: %i[revenue_by_customer_type customers_by_customer_type sales_by_customer_type]
  before_action :set_year, only: %i[production_yearly capacity_yearly]
  before_action :set_population_distribution, only: %i[age_distribution gender_distribution]

  def production_monthly; end
  def production_yearly; end
  def capacity_yearly; end
  def population_employment; end
  def average_sales_rates; end
  def revenue_by_customer_type; end
  def customers_by_customer_type; end
  def sales_by_customer_type; end
  def bulk_fuel_capacity_mix; end
  def gender_distribution; end
  def age_distribution; end
  def median_household_income; end

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

  def set_population_distribution
    return if params[:end_year].blank?

    @population_distribution = @community.population_age_sexes.find_by(end_year: params[:end_year].to_i)
  end
end
