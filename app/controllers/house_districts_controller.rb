class HouseDistrictsController < GroupedSummariesController
  include MetadataLookup

  private

  def set_parent
    @parent = HouseDistrict.friendly.find(params[:id])
  end

  def set_parents
    @parents = HouseDistrict.order(:name)
  end
  
  def default_map_layer
    "layer-boundary"
  end
end
