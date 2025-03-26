class MetadataController < ApplicationController
  before_action :set_metadatum, only: %i( download show )

  def index
    @search = search_params
    @highlighted = Metadatum.highlighted.all
    @topics = ActsAsTaggableOn::Tag.for_context(:topics)
  end

  def show
  end

  def search 
    @search = search_params
    @metadata = Metadatum

    if @search[:search].present?
      @metadata = @metadata.search_full_text(@search[:search])
    end

    if @search[:topic].present?
      @metadata = @metadata.tagged_with(@search[:topic], on: :topics)
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
    params.permit(:search, :order, :page, :topic, :commit)
  end
end
