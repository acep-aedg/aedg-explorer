# app/controllers/grids/summaries_controller.rb
module Grids
  class SummariesController < ApplicationController
    before_action :set_grid

    def capacity
      years = Capacity.available_years_for(@grid)
      year  = params[:year].presence&.to_i || years.first
      stats = Capacity.capacity_stats_for(@grid, year)

      render partial: 'shared/capacity_summary',
             locals: { owner: @grid, year: year, stats: stats }
    end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
