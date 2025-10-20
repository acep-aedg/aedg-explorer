module Grids
  class ChartsController < ApplicationController
    include Charts
    before_action :set_grid

    def production_monthly
      production_monthly_for(@grid)
    end

    def production_yearly
      production_yearly_for(@grid)
    end

    def capacity_yearly
      capacity_yearly_for(@grid)
    end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
