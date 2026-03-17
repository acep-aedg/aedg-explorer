class SearchesController < ApplicationController
  include Pagy::Method

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
    @communities = Community.all

    #  Apply Keyword Search
    @communities = @communities.search_related(params[:q]) if params[:q].present?

    # Gather search terms and UI state (like which panel is open)
    @filters      = extract_filters
    @state_params = state_params
    @facet_panels = build_facet_panels

    # Paginate main results; passing @state_params ensures "Next" links keep your checkboxes checked
    @pagy, @communities = pagy(:offset, build_scope(@filters),
                               page_key: "page",
                               limit: 25,
                               params: @state_params)

    # Generate the active filter badges for the sidebar
    prepare_active_filters

    respond_to do |format|
      format.html # Renders the whole page on first load
      format.turbo_stream do
        # We surgically update the results and badges without refreshing the whole page
        streams = [
          turbo_stream.update("results_frame", partial: "searches/advanced/results"),
          turbo_stream.update("active_filters_list", partial: "searches/advanced/active_filters")
        ]

        # If "Clear All" is clicked, we reset the hidden form so the checkboxes visually uncheck
        streams << turbo_stream.update("filter-form-container", partial: "searches/advanced/form") if params[:clear_all] == "true"

        # If user is just searching or paginating INSIDE a specific panel, we only update that panel
        streams << render_facet_update if params[:only_facet] == "true"

        render turbo_stream: streams.compact.flatten
      end
    end
  end

  private

  # This builds the data for the Grids, Boroughs, etc. side-panels
  def build_facet_panels
    Community.advanced_search_facets.map do |facet|
      prefix = facet[:prefix]
      # Some models use :name, others use :district; this picks the right sorting column
      col = prefix == "senate" ? :district : :name

      # Filter the sidebar list based on the small search box or alphabet buttons
      scope = facet[:model].filter_by_params(params, "q_#{prefix}", "alpha_#{prefix}", col)

      # Paginate the sidebar list (e.g., first 20 grids)
      pagy_item, items = pagy(:offset, scope,
                              page_key: "page_#{prefix}",
                              limit: 20,
                              params: state_params.merge(only_facet: "true", expanded: facet[:id]))

      facet.merge(
        items: items,
        pagy: pagy_item,
        available_letters: facet[:model].available_letters_for(col)
      )
    end
  end

  # This is the "Brain" of the search; it keeps track of every checkbox and UI state
  def state_params
    @state_params ||= begin
      facets = Community.advanced_search_facets

      # Scalar keys are simple strings/numbers
      scalar_keys = %w[q expanded page clear_all only_facet]
      scalar_keys += facets.map { |f| "alpha_#{f[:prefix]}" }
      scalar_keys += facets.map { |f| "q_#{f[:prefix]}" }
      scalar_keys += facets.map { |f| "page_#{f[:prefix]}" }

      # Array keys allow multiple checkboxes to be saved (e.g., grid_ids: [1, 2, 3])
      array_keys = facets.map { |f| f[:param].to_sym }.index_with { |_| [] }

      # permit ensures Rails doesn't block these parameters for security
      params.permit(*scalar_keys, **array_keys).to_h.compact_blank
    end
  end

  def render_facet_update
    prefix = determine_active_prefix
    facet  = @facet_panels.find { |f| f[:prefix] == prefix }

    # Exit early if we can't find the right panel
    return render turbo_stream: [] if prefix.blank? || !facet

    # Send back the HTML to swap out the frame
    turbo_stream.update("#{prefix}_frame",
                        partial: "searches/advanced/facet",
                        locals: { panel: facet })
  end

  def determine_active_prefix
    # Look for a facet matching a param key (q_ or alpha_)
    active_facet = Community.advanced_search_facets.find do |facet|
      params.keys.any? { |k| k.start_with?("q_#{facet[:prefix]}", "alpha_#{facet[:prefix]}") }
    end

    return active_facet[:prefix] if active_facet

    # Fallback to finding by the 'expanded' ID
    return if params[:expanded].blank?

    Community.advanced_search_facets.find { |f| f[:id] == params[:expanded] }&.dig(:prefix)
  end

  # Converts selected IDs into objects so we can show labels on the blue badges
  def prepare_active_filters
    @active_badges = []
    base_params = request.query_parameters.except(:expanded)

    Community.advanced_search_facets.each do |facet|
      param_values = Array(params[facet[:param]]).compact_blank
      next if param_values.empty?

      # Query the database for the selected items to get their names
      facet[:model].where(facet[:lookup] => param_values).find_each do |item|
        @active_badges << badge_for(item, facet, base_params)
      end
    end
  end

  # Logic for the "X" link on a badge; clicking it removes that specific ID from the URL
  def badge_for(item, facet, base_params)
    val = item.public_send(facet[:lookup]).to_s
    {
      label: badge_label(item, facet),
      checkbox_id: "#{facet[:prefix]}_#{val}",
      url: search_advanced_path(base_params.merge(
                                  facet[:param] => Array(params[facet[:param]]).map(&:to_s) - [val]
                                ))
    }
  end

  # Figures out if we should use a custom proc or a column name to show a badge's text
  def badge_label(item, facet)
    if facet[:label_method].is_a?(Proc)
      facet[:label_method].call(item)
    else
      item.public_send(facet[:label_method])
    end
  end

  # Simple helper to pull all selected facet IDs into a hash for the search scope
  def extract_filters
    filters = { q: params[:q] }
    Community.advanced_search_facets.each do |facet|
      filters[facet[:param]] = Array(params[facet[:param]]).compact_blank
    end
    filters
  end

  # The main database query; uses preload to fix the "82 queries" speed issue (N+1)
  def build_scope(filters)
    base = Community.preload(:borough, :regional_corporation, :grids, :senate_districts, :house_districts, :population)

    # Chain filters together based on what is present in the URL
    base = base.search_full_text(filters[:q]).reorder("communities.name ASC") if filters[:q].present?
    base = base.in_boroughs(filters[:borough_fips_codes])           if filters[:borough_fips_codes].present?
    base = base.in_corps(filters[:regional_corporation_fips_codes]) if filters[:regional_corporation_fips_codes].present?
    base = base.in_grids(filters[:grid_ids])                        if filters[:grid_ids].present?
    base = base.in_senate(filters[:senate_district_ids]) if filters[:senate_district_ids].present?
    base = base.in_house(filters[:house_district_ids]) if filters[:house_district_ids].present?

    base.distinct.all
  end
end
