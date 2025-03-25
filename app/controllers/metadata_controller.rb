class MetadataController < ApplicationController
  before_action :set_metadatum, only: %i( download show )

  def index
    @search = search_params
  end

  def show
  end

  def search 
    @search = search_params
    @metadata = if @search[:search].present?
      Metadatum.search_full_text(@search[:search])
    else
      Metadatum.all
    end
  end

  def download
    send_data @metadatum.data.to_json, filename: @metadatum.filename, type: 'application/json', disposition: 'attachment'
  end


  private 

  def set_metadatum
    @metadatum = Metadatum.friendly.find(params[:id])
  end

  def search_params
    params.permit(:search, :order, :page, :commit)
  end
end
