class GridsController < GroupedSummariesController
  include MetadataLookup

  # GET /grids/:slug
  def show
    redirect_to power_generation_grid_path(@parent), status: :see_other
  end

  private

  def set_parent
    @parent = Grid.friendly.find(params[:id])
  end

  def set_parents
    @parents = Grid.active.order(:name)
  end
end
