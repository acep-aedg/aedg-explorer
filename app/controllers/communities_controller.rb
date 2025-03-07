class CommunitiesController < ApplicationController
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

  def chart_data
    render json: {
      total_communities: Community.total_count,
      pce_labels: ["PCE Eligible", "Not Eligible"],
      pce_data: Community.pce_eligibility_count.values,
      bubble_data: Community.bubble_chart_data
    }, status: :ok
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end
end
