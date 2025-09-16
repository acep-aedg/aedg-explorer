class GridsController < ApplicationController
  before_action :set_grid, only: %i[show]

  # GET /grids
  def index
    @grids = Grid.active.order(:name)
  end

  # GET /grids/:slug
  def show
    @grids = Grid.active.order(:name)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grid
    @grid = Grid.friendly.find(params[:id])
  end
end
