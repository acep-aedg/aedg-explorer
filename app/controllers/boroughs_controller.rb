class BoroughsController < GroupedSummariesController
  include MetadataLookup

  private

  def set_parent
    @parent = Borough.friendly.find(params[:id])
  end

  def set_parents
    @parents = Borough.order(:name)
  end

  def default_map_layer
    @parent.boundary_map_layer
  end
end
