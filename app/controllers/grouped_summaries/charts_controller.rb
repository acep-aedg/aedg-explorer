module GroupedSummaries
  class ChartsController < ApplicationController
    before_action :set_year, only: %i[generation_monthly capacity_yearly]
    before_action :set_parent

    ALLOWED_GROUPS = { grid_id: Grid, house_district_id: HouseDistrict, senate_district_id: SenateDistrict }.freeze

    def generation_monthly; end
    def generation_yearly; end
    def capacity_yearly; end

    private

    def set_parent
      parent_key = ALLOWED_GROUPS.keys.detect { |key| chart_params[key].present? }

      if parent_key
        model_class = ALLOWED_GROUPS[parent_key]
        @parent = model_class.friendly.find(chart_params[parent_key])
      else
        render json: { error: "Resource not found" }, status: :not_found
      end
    end

    def set_year
      @year = chart_params[:year].presence&.to_i
    end

    def chart_params
      @chart_params ||= params.permit(
        :year,
        :format,
        *ALLOWED_GROUPS.keys,
        chart: {}
      )
    end
  end
end
