class CommunitiesController < ApplicationController
  require "ostruct"
  before_action :set_community, except: %i[index]
  before_action :set_communities
  layout :determine_layout

  def index
    @search_params = search_params 
    @query = @search_params[:q]
    @communities = Community.order(:name)
    @communities = @communities.search_related(@query) if @query.present?

    @active_letters = @communities.pluck(:name).map(&:first).uniq.sort

    @communities = @communities.starts_with(@search_params[:letter]) if @search_params[:letter].present?
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

  def determine_layout
    action_name == "index" ? "application" : "communities"
  end

  def get_related_metadata(slug)
    @related_metadata ||= {}
    @related_metadata[slug] ||= Metadatum.find_by(slug: slug)
  end
  helper_method :get_related_metadata

  def search_params
    params.permit(:q, :letter, :borough_fips_code, :regional_corporation_fips_code, :page, :per_page)
  end
end
