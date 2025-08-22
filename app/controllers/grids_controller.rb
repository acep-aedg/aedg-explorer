class GridsController < ApplicationController
  before_action :set_grid, only: %i[show]
  def index
    @grids = Grid.all.order(:name)
  end

  def show
    @grid = Grid.find(params[:id])
    @grids = Grid.all.order(:name)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grid
    @grid = Grid.find(params[:id])
  end
end
