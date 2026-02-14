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
    @pagy, @communities = pagy(build_scope(extract_filters), page_param: :page)

    @facet_panels = Community.advanced_search_facets.map do |facet|
      col = (facet[:prefix] == 'senate' || facet[:prefix] == 'house') ? :district : :name
      scope = facet[:model].filter_by_params(params, "q_#{facet[:prefix]}", "alpha_#{facet[:prefix]}", col)
      pagy_item, items = pagy(scope, page_param: "page_#{facet[:prefix]}")
      facet.merge(items: items, pagy: pagy_item)
    end
    # NEW: Global Filter Search Logic
    @global_search_results = []
    if params[:q_global].present?
      query = params[:q_global].downcase
      
      Community.advanced_search_facets.each do |facet|
        model = facet[:model]
        # Determine the correct column to search (name or district)
        search_col = model.column_names.include?('name') ? 'name' : 'district'
        
        # Run the query safely using the correct column
        matches = model.where("LOWER(CAST(#{search_col} AS TEXT)) LIKE ?", "%#{query}%").limit(5)

        matches.each do |match|
          @global_search_results << {
            label: match.respond_to?(:name) ? match.name : "District #{match.district}",
            category: facet[:title],
            param_key: facet[:param],
            value: match.send(facet[:lookup])
          }
      end
    end
  end



    prepare_active_filters

    respond_to do |format|
      format.html
      format.turbo_stream do
      render turbo_stream: [
        # Updates the map and community cards
        turbo_stream.replace("results_frame", partial: "searches/advanced/results"),
        
        # Updates the WHOLE sidebar (badges + resets buttons)
        turbo_stream.replace("sidebar_nav", partial: "searches/advanced/sidebar_nav"),
        
        # Updates the off-canvas panels
        turbo_stream.replace("search_panels_content", partial: "searches/advanced/panels")
      ]
      end
    end
  end

  private

  def prepare_active_filters
    @active_badges = []
    base_params = request.query_parameters.except(:expanded)

    Community.advanced_search_facets.each do |facet|
      next unless params[facet[:param]].present?

      facet[:model].where(facet[:lookup] => params[facet[:param]]).each do |item|
        val = item.send(facet[:lookup]).to_s
        lbl = if facet[:label_method].is_a?(Proc)
                facet[:label_method].call(item)
              else
                item.send(facet[:label_method])
              end

        @active_badges << {
          label: lbl,
          checkbox_id: "#{facet[:prefix]}_#{val}",
          url: search_advanced_path(base_params.merge(facet[:param] => Array(params[facet[:param]]) - [val]))
        }
      end
    end
  end

  def extract_filters
    {
      q: params[:q],
      # Using Array() ensures that even a single ID is treated as a list
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
