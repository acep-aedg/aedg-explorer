class CommunitiesController < ApplicationController
  require 'ostruct'
  before_action :set_community, only: :show

  def index
    @query = params[:q].to_s.strip

    scope = Community.all
    scope = apply_search(scope)
    scope = apply_region_filters(scope)
    scope = apply_letter_filter(scope)
    @communities = scope.order(:name)

    if turbo_frame_request?
      render partial: 'communities/communities_list_frame', locals: { communities: @communities }
      return
    end

    base = Community.unscoped
    @boroughs = grouped_counts(base, :borough_fips_code)
    @native_corporations = grouped_counts(base, :regional_corporation_fips_code)
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

  def apply_search(scope)
    q = params[:q].to_s.strip
    return scope if q.blank?

    scope.search_full_text(q)
  end

  def apply_region_filters(scope)
    scope = scope.where(borough_fips_code: params[:borough_fips_code]) if params[:borough_fips_code].present?
    scope = scope.where(regional_corporation_fips_code: params[:regional_corporation_fips_code]) if params[:regional_corporation_fips_code].present?
    scope
  end

  def apply_letter_filter(scope)
    letter = params[:letter].to_s.strip
    return scope if letter.blank?

    first = letter[0]&.upcase
    return scope unless first =~ /\A[A-Z]\z/

    scope.where('communities.name ILIKE ?', "#{first}%")
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
