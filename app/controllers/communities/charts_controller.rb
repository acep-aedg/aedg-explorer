class Communities::ChartsController < ApplicationController
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

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private
    def set_community
        @community = Community.find(params[:community_id])
    end
end

