class HouseDistrictsController < GroupedSummariesController
  include MetadataLookup

  private

  def set_parent
    @parent = HouseDistrict.friendly.find(params[:id])
  end

  def set_parents
    @parents = HouseDistrict.order(:name)
  end

  def general_map_buttons
    buttons = super
    buttons + [
      {
        label: "District Boundary",
        url: polymorphic_path([:boundary, @parent, :maps]),
        icon: "bounding-box",
        id: "layer-boundary",
        visible: @parent.boundary?
      }
    ]
  end

  def default_map_layer
    "layer-boundary"
  end
end
