class GridsController < GroupedSummariesController
  include MetadataLookup

  # GET /grids/:slug
  def show
    redirect_to power_generation_grid_path(@grid), status: :see_other
  end

  private

  def set_parent
    @parent = Grid.friendly.find(params[:id])
  end

  def set_parents
    @parents = Grid.active.order(:name)
  end

  def set_page_title
    base_name = "Electric Grids"

    @page_title = case action_name
                  when "index"
                    base_name
                  else
                    @parent.present? ? "#{base_name} - #{@parent.name}" : base_name
                  end
  end
end
