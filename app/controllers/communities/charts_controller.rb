class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  before_action :set_community

  def production_monthly
    latest_year = MonthlyGeneration.latest_year_for(@community.grid)
    grouped_data = @community.grid.monthly_generations.where(year: latest_year).grouped_net_generation_by_year_month

    dataset = grouped_data.keys.map(&:first).uniq.sort.map do |year|
      monthly_data = (1..12).map do |month|
        [Date::ABBR_MONTHNAMES[month], grouped_data.fetch([year, month], 0)]
      end.to_h
      { name: year.to_s, data: monthly_data }
    end
    render json: dataset
  end

  def production_yearly
    latest_year = YearlyGeneration.latest_year_for(@community.grid)
    data = @community.grid.yearly_generations.where(year: latest_year).grouped_net_generation_by_fuel_type
    dataset = data.map { |fuel_type, value| [fuel_type.to_s, value] }
    render json: dataset
  end

  def capacity_yearly
    latest_year = Capacity.latest_year_for(@community.grid)
    data = @community.grid.capacities.where(year: latest_year).grouped_capacity_by_fuel_type
    dataset = data.map { |fuel_type, value| [fuel_type.to_s, value] }
    render json: dataset
  end

  def population_employment
    employments = @community.employments.sort_by(&:measurement_year)
    render json: employment_chart_data(employments)
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
