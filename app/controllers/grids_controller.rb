class GridsController < GroupedSummariesController
  include MetadataLookup

  # GET /grids
  def index
    @search_params = search_params

    @query = @search_params[:q]

    @grids = @grids.search_related(@query) if @query.present?

    @active_letters = @grids.pluck(:name).map { |n| n[0].upcase }.uniq.sort

    @grids = @grids.starts_with(@search_params[:letter]) if @search_params[:letter].present?
  end

  # GET /grids/:slug
  def show
    redirect_to power_generation_grid_path(@grid), status: :see_other
  end

  def general; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parent
    @grid = Grid.friendly.find(params[:id])
    @parent = @grid
  end

  def set_parents
    @grids = Grid.active.order(:name)
    @parents = @grids
  end

  def set_page_title
    @page_title = "Electric Grids - #{@parent&.name}"
  end

  def search_params
    params.permit(:q, :letter, :page, :per_page)
  end
end
