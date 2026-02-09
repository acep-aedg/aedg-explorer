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
    # --- MAIN COMMUNITY SEARCH ---
    @pagy, @communities = pagy(build_scope(extract_filters), page_param: :page)

    # --- SIDEBAR FACETS ---
    @pagy_grids, @current_grids = pagy(Grid.filter_by_params(params, :q_grid, :alpha_grid), page_param: :page_grid)
    @pagy_boros, @current_boros = pagy(Borough.filter_by_params(params, :q_boro, :alpha_boro), page_param: :page_boro)
    @pagy_corps, @current_corps = pagy(RegionalCorporation.filter_by_params(params, :q_corp, :alpha_corp), page_param: :page_corp)
    @pagy_senate, @current_senate = pagy(SenateDistrict.filter_by_params(params, :q_senate, :alpha_senate, :district), page_param: :page_senate)
    @pagy_house, @current_house = pagy(HouseDistrict.filter_by_params(params, :q_house, :alpha_house, :district), page_param: :page_house)

    respond_to do |format|
      format.html # Full page load
      format.turbo_stream do
        render turbo_stream: [
          # Update Sidebar Badges
          turbo_stream.replace("active_filters_frame",
                               partial: "searches/advanced/active_filters"),

          # Update Results List
          turbo_stream.replace("results_frame",
                               partial: "searches/advanced/results",
                               locals: { communities: @communities, pagy: @pagy })
        ]
      end
    end
  end

  private

  def extract_filters
    {
      q: params[:q],
      grid_ids: Array(params[:grid_ids]).compact_blank,
      borough_fips_codes: Array(params[:borough_fips_codes]).compact_blank,
      regional_corporation_fips_codes: Array(params[:regional_corporation_fips_codes]).compact_blank,
      senate_district_ids: Array(params[:senate_district_ids]).compact_blank,
      house_district_ids: Array(params[:house_district_ids]).compact_blank
    }
  end

  def build_scope(filters)
    # base scope
    base = Community.preload(:borough, :regional_corporation, :grids, :senate_districts, :house_districts)
    # Text search (pg_search_scope)
    if filters[:q].present?
      base = base.search_full_text(filters[:q])
                 .reorder("communities.name ASC")
    end
    # Apply filters
    base = base.in_boroughs(filters[:borough_fips_codes])           if filters[:borough_fips_codes].present?
    base = base.in_corps(filters[:regional_corporation_fips_codes]) if filters[:regional_corporation_fips_codes].present?
    base = base.in_grids(filters[:grid_ids])                        if filters[:grid_ids].present?
    base = base.in_senate(filters[:senate_district_ids])            if filters[:senate_district_ids].present?
    base = base.in_house(filters[:house_district_ids])              if filters[:house_district_ids].present?

    base.distinct.all
  end

  def preload_choices
    @all_grids = Grid.order(:name).select(:id, :name)
    @all_boros = Borough.order(:name).select(:fips_code, :name)
    @all_corps = RegionalCorporation.order(:name).select(:fips_code, :name)
    @all_senate = SenateDistrict.order(:district).select(:id, :district)
    @all_house  = HouseDistrict.order(:district).select(:id, :district, :name)
  end
end
