class CommunitiesController < ApplicationController
  include ChartHelpers
  before_action :set_community, only: %i[ show ]

  # GET /communities or /communities.json
  def index
    @communities = Community.all
  end

  # GET /communities/1 or /communities/1.json
  def show
    @community = Community.find(params[:id])
    @borough = @community.borough
    @communities = Community.all
  end

  def production_monthly_data
    community = Community.find(params[:id])
    chart_data = generate_monthly_chart_data(community)
    render json: chart_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end
end
