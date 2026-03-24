class GroupedSummariesController < ApplicationController
  before_action :set_parent, except: %i[index]
  before_action :set_tab_links, :set_map_buttons, only: %i[power_generation]

  def index; end
  def power_generation; end

  def set_map_buttons
    @map_buttons = case action_name
                   when "power_generation"
                     power_generation_map_buttons
                   end
  end

  def set_tab_links
    @tab_links = case action_name
                 when "power_generation"
                   power_generation_tab_links
                 end
  end

  def power_generation_map_buttons; end

  def power_generation_tab_links
    [
      { title: "Utilities", anchor: "#utilities", icon: "buildings", show: @parent.show_utilities? },
      { title: "Generation", anchor: "#generation", icon: "building-gear", show: @parent.show_generation? },
      { title: "Capacity", anchor: "#capacity", icon: "lightning-fill", show: @parent.show_capacity? }
    ]
  end
end
