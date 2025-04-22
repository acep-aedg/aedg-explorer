class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  before_action :set_community

  def production_monthly
    grouped_data = @community.grid.monthly_generations.grouped_net_generation_by_year_month

    dataset = grouped_data.keys.map(&:first).uniq.sort.map do |year|
      monthly_data = (1..12).map do |month|
        [Date::ABBR_MONTHNAMES[month], grouped_data.fetch([year, month], 0)]
      end.to_h
      { name: year.to_s, data: monthly_data }
    end

    render json: dataset
  end

  def production_yearly
    grouped_data = @community.grid.yearly_generations.grouped_net_generation_by_year
    dataset = grouped_data.map { |year, value| [year.to_s, value] }
    render json: dataset
  end

  def capacity_yearly
    dataset = @community.grid.capacities.latest_year.group(:fuel_type).sum(:capacity_mw)
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
