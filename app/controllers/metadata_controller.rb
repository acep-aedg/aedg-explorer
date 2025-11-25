class MetadataController < ApplicationController
  before_action :set_metadatum, only: %i[download show]
  before_action :set_dataset, only: %i[show]

  def index
    @search = search_params
    @highlighted = Metadatum.highlighted.all
    @topics = ActsAsTaggableOn::Tag.for_context(:topics)
  end

  def show; end

  def search
    @search = search_params
    @topics = ActsAsTaggableOn::Tag.for_context(:topics)
    @metadata = Metadatum

    @metadata = @metadata.search_full_text(@search[:search]) if @search[:search].present?

    @metadata = @metadata.tagged_with(@search[:topic], on: :topics) if @search[:topic].present?

    @metadata = @metadata.highlighted if @search[:featured].to_i == 1

    @communities = Community.search_related(@search[:search]).reorder(:name) if @metadata.count.zero? && @search[:search].present?

    @metadata = @metadata.all
  end

  def download
    send_data @metadatum.data.to_json, filename: @metadatum.filename, type: 'application/json',
                                       disposition: 'attachment'
  end

  private

  def set_metadatum
    @metadatum = Metadatum.friendly.find(params[:id])
  end

  def set_dataset
    @dataset = @metadatum.dataset
  end

  def search_params
    params.permit(:search, :order, :page, :topic, :featured, :commit)
  end
end
