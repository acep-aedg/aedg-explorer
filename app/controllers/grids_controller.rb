class GridsController < ApplicationController
  before_action :set_grid, only: %i[show]

  # GET /grids
  def index
    @search_params = search_params 
    
    @query = @search_params[:q]
    @grids = Grid.active.order(:name)

    @grids = @grids.search_related(@query) if @query.present?
    
    @active_letters = @grids.pluck(:name).map { |n| n[0].upcase }.uniq.sort
    
    @grids = @grids.starts_with(@search_params[:letter]) if @search_params[:letter].present?
  end

  # GET /grids/:slug
  def show
    @grids = Grid.active.order(:name)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grid
    @grid = Grid.friendly.find(params[:id])
  end

  def search_params
    params.permit(:q, :letter, :page, :per_page)
  end
end
