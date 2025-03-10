class DatasetsController < ApplicationController
  #before_action :set_dataset, only: %i[ show ]

  # GET /datasets or /datasets.json
  def index
  end

  # GET /datasets/1 or /datasets/1.json
  def show
  end
  
  def explore
    @communities_count = Community.count
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dataset_params
      params.fetch(:dataset, {})
    end
end
