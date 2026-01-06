require 'open-uri'
class DatasetsController < ApplicationController
  before_action :set_metadatum
  before_action :set_dataset, only: %i[show]

  # GET /datasets/1 or /datasets/1.json
  def show
    respond_to do |format|
      # This is a workaround for rendering the data out to the datatables
      format.json { render json: data_as_json }
      format.any  { head :not_acceptable }
    end
  end

  private

  def data_as_json
    case @dataset.format.downcase
    when 'csv'
      fields = @dataset.schema['fields'].map { |f| f['name'] }
      data = CSV.parse(URI.open(@dataset.path).read, headers: true).map do |row|
        fields.index_with { |f| row[f] }
      end
      {
        recordsTotal: data.size,
        data: data,
        columns: @dataset.schema['fields'].map { |f| { data: f['name'], title: f['name'] } }
      }.to_json
    when 'geojson'
      JSON.parse(URI.open(@dataset.path).read)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_metadatum
    @metadatum = Metadatum.friendly.find(params[:metadatum_id])
  end

  def set_dataset
    @dataset = @metadatum.dataset
  end
end
