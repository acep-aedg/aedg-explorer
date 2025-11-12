class CommunitiesController < ApplicationController
  require 'ostruct'
  before_action :set_community, only: :show
  before_action :set_search_params, only: :index

  def index
    @query = @search_params[:q]

    @communities = Community
    @communities = @communities.search_full_text(@query) unless @query.blank?
    @communities = @communities.in_borough(params[:regional_corporation_fips_code]) unless params[:regional_corporation_fips_code].blank?
    @communities = @communities.starts_with(params[:letter]) unless params[:letter].blank?

    @communities =@communities.order(:name).all
  end

  def show
    @borough = @community.borough
    @communities = Community.all
    @available_price_types = @community.available_price_types
    @selected_price_type = (params[:price_type] if @available_price_types.include?(params[:price_type])) || @available_price_types.first
  end

  private

  def set_community
    @community = Community.friendly.find(params[:id])
  end

  def set_search_params
    allowed = %i[q letter borough_fips_code regional_corporation_fips_code page per_page]
    @search_params = params.permit(*allowed).to_h.symbolize_keys
  end
end
