class MetadataController < ApplicationController
  before_action :set_metadatum, only: %i( show )

  def index
    @search = search_params
  end

  def show
  end

  def search 
    @search = search_params
    @metadata = Metadatum.all
  end

  private 

  def set_metadatum
    @metadatum = Metadatum.friendly.find(params[:id])
  end

  def search_params
    params.permit(:search, :order, :page)
  end
end
