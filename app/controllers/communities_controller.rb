class CommunitiesController < ApplicationController
  require 'ostruct'
  before_action :set_community, only: :show
  before_action :set_search_params, only: :index

  def index
    @query = @search_params[:q].to_s.strip

    scope = Community.all
    scope = apply_search(scope)
    scope = apply_region_filters(scope)
    scope = apply_letter_filter(scope)

    @communities = scope.order(:name)
  end

  def show
    @borough = @community.borough
    @communities = Community.all
    @available_price_types = @community.available_price_types
    @selected_price_type =
      (params[:price_type] if @available_price_types.include?(params[:price_type])) ||
      @available_price_types.first
  end

  private

  def set_community
    @community = Community.friendly.find(params[:id])
  end

  def set_search_params
    allowed = %i[q letter borough_fips_code regional_corporation_fips_code page per_page]
    @search_params = params.permit(*allowed).to_h.symbolize_keys
  end

  def apply_search(scope)
    q = @search_params[:q].to_s.strip
    return scope if q.blank?

    scope.search_full_text(q)
  end

  def apply_region_filters(scope)
    scope = scope.where(borough_fips_code: @search_params[:borough_fips_code]) if @search_params[:borough_fips_code].present?
    scope = scope.where(regional_corporation_fips_code: @search_params[:regional_corporation_fips_code]) if @search_params[:regional_corporation_fips_code].present?
    scope
  end

  def apply_letter_filter(scope)
    l = @search_params[:letter].to_s.strip
    return scope if l.blank?

    scope.starts_with(l)
  end
end
