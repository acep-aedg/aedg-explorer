class Communities::ChartsController < ApplicationController
  before_action :set_community
  before_action :set_year,
                only: %i[capacity_yearly generation_monthly customer_breakdown_revenue customer_breakdown_customers customer_breakdown_sales energy_sold energy_sold_stacked]
  before_action :set_sales, only: %i[customer_breakdown_revenue customer_breakdown_customers customer_breakdown_sales energy_sold energy_sold_stacked]

  def generation_monthly; end
  def generation_yearly; end
  def capacity_yearly; end
  def population_employment; end
  def customer_breakdown_revenue; end
  def customer_breakdown_customers; end
  def customer_breakdown_sales; end
  def bulk_fuel_capacity_mix; end
  def sex_distribution; end
  def poverty_rate; end
  def household_income_brackets; end
  def income; end
  def energy_sold; end
  def energy_sold_stacked; end
  def electric_rates; end

  def age_distribution
    @end_year = params[:end_year].presence&.to_i
  end

  def fuel_prices
    @price_type = params[:price_type].to_s
    @fuel_prices = @community.fuel_prices
    @heating_degree_days = @community.heating_degree_days
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end

  def set_sales
    @sales = @community.sales.where(year: @year)
  end

  def set_year
    @year = params[:year].presence&.to_i
  end
end
