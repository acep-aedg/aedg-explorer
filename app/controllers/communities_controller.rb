# app/controllers/communities_controller.rb
require 'ostruct'
class CommunitiesController < ApplicationController
  before_action :set_community, only: :show

  # GET /communities
  def index
    scope = Community.all
    scope = apply_search(scope)
    scope = apply_region_filters(scope)
    @communities = scope.order(:name)

    if params[:only_list].present?
      cols = (params[:columns] || 5).to_i
      show = params[:show_jump].to_s != '0'
      render partial: 'community_list', locals: { communities: @communities, frame_id: params[:frame_id], columns: cols, show_jump: show }, layout: false and return
    end

    base = Community.unscoped
    @boroughs = grouped_counts(base, :borough_fips_code)
    @native_corporations = grouped_counts(base, :regional_corporation_fips_code)
  end

  # GET /communities/:id
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

  def apply_search(scope)
    return scope unless params[:q].present?

    q = "%#{params[:q].strip}%"
    scope.where(
      'communities.name ILIKE :q OR communities.fips_code ILIKE :q OR communities.gnis_code ILIKE :q',
      q: q
    )
  end

  def apply_region_filters(scope)
    scope = scope.where(borough_fips_code: params[:borough_fips_code]) if params[:borough_fips_code].present?
    if params[:regional_corporation_fips_code].present?
      scope = scope.where(regional_corporation_fips_code: params[:regional_corporation_fips_code])
    end
    scope
  end

  def grouped_counts(base, column)
    base
      .where.not(column => [nil, ''])
      .reorder(nil)
      .group(column)
      .count
      .map { |code, count| OpenStruct.new(code: code, communities_count: count) }
      .sort_by { |obj| obj.code.to_s }
  end
end
