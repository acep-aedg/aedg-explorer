class HouseDistrictsController < GroupedSummariesController
  include MetadataLookup

  private

  def set_parent
    @parent = HouseDistrict.friendly.find(params[:id])
  end

  def set_parents
    @parents = HouseDistrict.order(:district)
  end

  def default_map_layer
    @parent.boundary_map_layer
  end
end
