class Communities::ChartsController < ApplicationController
  before_action :set_community
  before_action :set_latest_sale, only: %i[customer_breakdown_revenue customer_breakdown_customers customer_breakdown_sales]
  before_action :set_sales, only: %i[energy_sold energy_sold_stacked]
  before_action :set_year, only: %i[production_yearly capacity_yearly production_monthly]
  before_action :set_population_distribution, only: %i[age_distribution gender_distribution]

  def production_monthly; end
  def production_yearly; end
  def capacity_yearly; end
  def population_employment; end
  def customer_breakdown_revenue; end
  def customer_breakdown_customers; end
  def customer_breakdown_sales; end
  def bulk_fuel_capacity_mix; end
  def gender_distribution; end
  def age_distribution; end
  def poverty_rate; end
  def household_income_brackets; end
  def income; end
  def energy_sold; end
  def energy_sold_stacked; end

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

  def set_latest_sale
    @latest_sale = @community.reporting_entity&.latest_sale
  end

  def set_sales
    @sales = @community.sales.order(year: :asc) || []
  end

  def set_year
    @year = params[:year].presence&.to_i
  end

  def set_population_distribution
    return if params[:end_year].blank?

    @population_distribution = @community.population_age_sexes.find_by(end_year: params[:end_year].to_i)
  end
end
