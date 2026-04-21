class RegionalCorporationsController < GroupedSummariesController
  include MetadataLookup

  private

  def set_parent
    @parent = RegionalCorporation.friendly.find(params[:id])
  end

  def set_parents
    @parents = RegionalCorporation.order(:name)
  end

  def default_map_layer
    @parent.boundary_map_layer
  end
end
