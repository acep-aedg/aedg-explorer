class GroupedSummariesController < ApplicationController
  layout :determine_layout
  before_action :set_parent, except: %i[index]
  before_action :set_parents
  before_action :set_jump_to_links, :set_map_buttons, only: %i[power_generation]
  before_action :set_nav_tab_links, only: %i[general power_generation]
  before_action :set_page_title

  def index; end
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

  def set_page_title
    @page_title = "#{controller_name.humanize} - #{@parent&.name}"
  end

  def set_map_buttons
    @map_buttons = case action_name
                   when "power_generation"
                     power_generation_map_buttons
                   end
  end

  def set_jump_to_links
    @jump_to_links = case action_name
                     when "power_generation"
                       power_generation_jump_to_links
                     end
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

  def power_generation_jump_to_links
    [
      { title: "Utilities", anchor: "#utilities", icon: "buildings", show: @parent.utilities? },
      { title: "Generation", anchor: "#generation", icon: "building-gear", show: @parent.generation? },
      { title: "Capacity", anchor: "#capacity", icon: "lightning-fill", show: @parent.capacities? }
    ]
  end
end
