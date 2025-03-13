class Communities::ChartsController < ApplicationController
  before_action :set_community

  def production_monthly_data
    grouped_data = @community.grid.monthly_generations.group(:year, :month).sum(:net_generation_mwh)
    numeric_months = @community.grid.monthly_generations.pluck(:month).uniq.sort
    labels = numeric_months.map { |month| Date::ABBR_MONTHNAMES[month] }

    dataset = numeric_months.map do |month|
      total_mwh = grouped_data.select { |(_, m), _| m == month }.values.sum
      [Date::ABBR_MONTHNAMES[month], total_mwh] # Chartkick expects [Label, Value] format
    end.to_h

    render json: dataset
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private
    def set_community
        @community = Community.find(params[:community_id])
    end
end

