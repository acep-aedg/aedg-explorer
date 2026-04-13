class GroupedSummariesController < ApplicationController
  layout :determine_layout
  before_action :set_parent, except: %i[index]
  before_action :set_parents
  before_action :set_jump_to_links, :set_map_buttons, only: %i[general power_generation]
  before_action :set_nav_tab_links, only: %i[general power_generation]

  def index
    @search_params = search_params
    @query = @search_params[:q]
    @parents = @parents.search_related(@query) if @query.present?
    @active_letters = @parents.pluck(@parents.searchable_column).map { |n| n[0].upcase }.uniq.sort
    @parents = @parents.starts_with(@search_params[:letter]) if @search_params[:letter].present?
  end

  def show
    redirect_to polymorphic_path([:general, @parent]), status: :see_other
  end

  def general; end
  def power_generation; end

  private

  # Implemented by subclasses
  def set_parent; end

  # Implemented by subclasses
  def set_parents; end

  def determine_layout
    action_name == "index" ? "application" : "grouped_summaries"
  end

  def search_params
    params.permit(:q, :letter, :page, :per_page)
  end

  def set_map_buttons
    @map_buttons = case action_name
                   when "general"
                     general_map_buttons
                   when "power_generation"
                     power_generation_map_buttons
                   end
  end

  def set_jump_to_links
    @jump_to_links = case action_name
                     when "general"
                       general_jump_to_links
                     when "power_generation"
                       power_generation_jump_to_links
                     end
  end

  helper_method :default_map_layer

  def default_map_layer
    "layer-communities"
  end

  def set_nav_tab_links
    @nav_tab_links = [
      {
        label: "General",
        path: polymorphic_path([:general, @parent]),
        visible: true
      },
      {
        label: "Power Generation",
        path: polymorphic_path([:power_generation, @parent]),
        visible: @parent.generation?
      }
    ].select { |tab| tab[:visible] }
  end

  def power_generation_map_buttons
    [
      {
        label: "Utility Service Areas",
        url: polymorphic_path([:service_areas, @parent, :maps]),
        icon: "bounding-box",
        id: "layer-service-area-utility",
        visible: @parent.service_areas?
      },
      {
        label: "Power Plants",
        url: polymorphic_path([:plants, @parent, :maps]),
        icon: "building",
        id: "layer-plants",
        visible: @parent.plants?
      }
    ]
  end

  def general_map_buttons
    [
      {
        label: "Communities",
        url: polymorphic_path([:community_locations, @parent, :maps]),
        icon: "people",
        id: "layer-communities",
        visible: @parent.communities?
      }
    ] + (
      if @parent.boundary?
        [
          {
            label: "District Boundary",
            url: polymorphic_path([:boundary, @parent, :maps]),
            icon: "bounding-box",
            id: @parent.boundary_map_layer,
            visible: true
          }
        ]
      else
        []
      end
    )
  end

  def general_jump_to_links
    [
      { title: "Overview", anchor: "#overview", icon: "globe", show: true }
    ]
  end

  def power_generation_jump_to_links
    [
      { title: "Utilities", anchor: "#utilities", icon: "buildings", show: @parent.utilities? },
      { title: "Generation", anchor: "#generation", icon: "building-gear", show: @parent.generation? },
      { title: "Capacity", anchor: "#capacity", icon: "lightning-fill", show: @parent.capacities? }
    ]
  end
end
