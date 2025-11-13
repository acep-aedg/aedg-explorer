class SearchesController < ApplicationController
  include Pagy::Backend

  def index
    @query = params[:q]
    @communities = Community.none
    @communities = Community.search_full_text(@query) if @query.present?
  end

  def show
    @query = params[:q]
    @communities = Community.search(@query) if @query.present?
  end

  def advanced
    filters = extract_filters
    @query  = filters[:q]
    preload_choices

    scope = build_scope(filters).includes(:borough, :regional_corporation, :grids, :senate_districts, :house_districts).distinct.order(:name)
    @pagy, @communities = pagy(scope)
  end

  private

  def extract_filters
    {
      q: params[:q].to_s.strip.presence,
      grid_ids: Array(params[:grid_ids]).reject(&:blank?),
      borough_fips_codes: Array(params[:borough_fips_codes]).reject(&:blank?),
      regional_corporation_fips_codes: Array(params[:regional_corporation_fips_codes]).reject(&:blank?),
      senate_district_ids: Array(params[:senate_district_ids]).reject(&:blank?),
      house_district_ids: Array(params[:house_district_ids]).reject(&:blank?)
    }
  end

  def build_scope(filters)
    Community
      .search_full_text(filters[:q])
      .in_boroughs(filters[:borough_fips_codes])
      .in_corps(filters[:regional_corporation_fips_codes])
      .in_grids(filters[:grid_ids])
      .in_senate(filters[:senate_district_ids])
      .in_house(filters[:house_district_ids])
  end

  def preload_choices
    @all_grids = Grid.order(:name).select(:id, :name)
    @all_boros = Borough.order(:name).select(:fips_code, :name)
    @all_corps = RegionalCorporation.order(:name).select(:fips_code, :name)
    @all_senate = SenateDistrict.order(:district).select(:id, :district)
    @all_house  = HouseDistrict.order(:district).select(:id, :district, :name)
  end
end
