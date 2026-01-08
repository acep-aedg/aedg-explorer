module Grids
  class ChartsController < ApplicationController
    before_action :set_grid
    before_action :set_year

    def production_monthly; end
    def production_yearly; end
    def capacity_yearly; end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end

    def set_year
      @year = params[:year].presence&.to_i
    end
  end
end
