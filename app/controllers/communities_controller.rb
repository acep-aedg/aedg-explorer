class CommunitiesController < ApplicationController
  before_action :set_community, only: %i[ show ]
  before_action :set_sorted_communities, only: %i[ show index ]

  # GET /communities or /communities.json
  def index
  end

  # GET /communities/1 or /communities/1.json
  def show
    @community = Community.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    def set_sorted_communities
      @communities = Community.all.order(:name)
    end

    # Only allow a list of trusted parameters through.
    def community_params
      params.require(:community).permit(:fips_code, :name, :latitude, :longitude, :ansi_code, :community_id, :global_id)
    end
end
