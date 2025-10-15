# app/controllers/communities/summaries_controller.rb
module Communities
  class SummariesController < ApplicationController
    before_action :set_community

    def capacity
      years = Capacity.available_years_for(@community)
      year  = params[:year].presence&.to_i || years.first
      stats = Capacity.capacity_stats_for(@community, year)

      render partial: 'shared/capacity_summary',
             locals: { owner: @community, year: year, stats: stats }
    end

    private

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end
  end
end
