# app/controllers/grids/summaries_controller.rb
module Grids
  class SummariesController < Shared::BaseSummariesController
    before_action :set_grid

    private

    def set_grid = @grid = Grid.friendly.find(params[:grid_id])
    def owner = @grid
  end
end
