module Grids
  class ChartsController < ApplicationController
    include Charts
    before_action :set_grid

    def production_monthly
      render json: production_monthly_for(@grid)
    end

    def production_yearly
      render json: production_yearly_for(@grid, params[:year].presence&.to_i)
    end

    def capacity_yearly
      render json: capacity_yearly_for(@grid, params[:year].presence&.to_i)
    end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
