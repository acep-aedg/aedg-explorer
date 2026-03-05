class GridsController < ApplicationController
  include MetadataLookup

  before_action :set_grid, except: %i[index]
  before_action :set_grids
  layout :determine_layout

  # GET /grids
  def index; end

  # GET /grids/:slug
  def show
    redirect_to general_grid_path(@grid), status: :see_other
  end

  def general; end
  def power_generation; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grid
    @grid = Grid.friendly.find(params[:id])
  end

  def set_grids
    @grids = Grid.active.order(:name)
  end

  def determine_layout
    action_name == "index" ? "application" : "grids"
  end
end
