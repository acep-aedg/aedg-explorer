class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  before_action :set_community

  def production_monthly
    grouped_data = @community.grid.monthly_generations.group(:year, :month).sum(:net_generation_mwh)
    numeric_months = @community.grid.monthly_generations.pluck(:month).uniq.sort
    labels = numeric_months.map { |month| Date::ABBR_MONTHNAMES[month] }

    dataset = numeric_months.map do |month|
      total_mwh = grouped_data.select { |(_, m), _| m == month }.values.sum
      [Date::ABBR_MONTHNAMES[month], total_mwh] # Chartkick expects [Label, Value] format
    end.to_h

    render json: dataset
  end

  def population_employment
    employment_chart_data = employment_chart_data(@community.employments.sort_by(&:measurement_year))
    employments = @community.employments.sort_by(&:measurement_year)
    render json: employment_chart_data(employments)
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private
    def set_community
        @community = Community.find(params[:community_id])
    end
end
