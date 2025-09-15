class CommunitiesController < ApplicationController
  before_action :set_community, only: %i[show]

  # GET /communities or /communities.json
  def index
    @communities = Community.all
  end

  # GET /communities/1 or /communities/1.json
  def show
    @borough = @community.borough
    @communities = Community.all
    @available_price_types = @community.available_price_types
    @selected_price_type = (params[:price_type] if @available_price_types.include?(params[:price_type])) || @available_price_types.first
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.friendly.find(params[:id])
  end
end
