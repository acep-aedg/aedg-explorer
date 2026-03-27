class HouseDistrictsController < ApplicationController
  include MetadataLookup

  # GET /grids/:slug
  def show
    redirect_to power_generation_house_district_path(@house_district), status: :see_other
  end

  def general; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parent
    @house_district = HouseDistrict.find(params[:id])
    @parent = @house_district
  end

  def set_parents
    @house_districts = HouseDistrict.active.order(:name)
    @parents = @house_districts
  end

  def search_params
    params.permit(:q, :letter, :page, :per_page)
  end
end

