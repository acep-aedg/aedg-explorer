class CommunitiesController < ApplicationController
  require "ostruct"
  before_action :set_community, except: %i[index]
  before_action :set_communities
  before_action :set_search_params, only: :index
  layout :determine_layout

  def index
    @query = @search_params[:q]
    @communities = Community.order(:name)
    @communities = @communities.search_related(@query) if @query.present?

    @active_letters = @communities.pluck(:name).map(&:first).uniq.sort

    @communities = @communities.starts_with(params[:letter]) if params[:letter].present?
    @communities = @communities.all
  end

  def show
    redirect_to general_community_path(@community), status: :see_other
  end

  def general; end
  def power_generation; end
  def electric_rates_sales; end

  def fuel
    @available_price_types = @community.available_price_types
    @selected_price_type = (params[:price_type] if @available_price_types.include?(params[:price_type])) || @available_price_types.first
  end

  def demographics; end
  def income; end

  private

  def set_community
    @community = Community.friendly.find(params[:id])
  end

  def set_communities
    @communities = Community.order(:name)
  end

  def set_search_params
    allowed = %i[q letter borough_fips_code regional_corporation_fips_code page per_page]
    @search_params = params.permit(*allowed).to_h.symbolize_keys
  end

  def determine_layout
    action_name == "index" ? "application" : "communities"
  end
end
