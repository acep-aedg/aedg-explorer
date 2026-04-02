class BoroughsController < GroupedSummariesController
  include MetadataLookup

  # GET /house_districts/:slug
  def show
    redirect_to power_generation_borough_path(@parent), status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parent
    @parent = Borough.friendly.find(params[:id])
  end

  def set_parents
    @parents = Borough.order(:name)
  end
end
