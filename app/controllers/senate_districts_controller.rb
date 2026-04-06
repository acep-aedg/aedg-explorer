class SenateDistrictsController < GroupedSummariesController
  include MetadataLookup

  protected

  def search_column
    :district
  end

  private

  def set_parent
    @parent = SenateDistrict.friendly.find(params[:id])
  end

  def set_parents
    @parents = SenateDistrict.order(:district)
  end
end
