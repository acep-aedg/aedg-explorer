class SenateDistrictsController < GroupedSummariesController
  include MetadataLookup

  private

  def set_parent
    @parent = SenateDistrict.friendly.find(params[:id])
  end

  def set_parents
    @parents = SenateDistrict.order(:district)
  end

  def default_map_layer
    "layer-boundary"
  end
end
