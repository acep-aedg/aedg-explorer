module Grids
  class MapsController < ApplicationController
    before_action :set_grid

    def community_locations; end
    def service_area_geoms; end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
