module GroupedSummaries
  class ChartsController < ApplicationController
    before_action :set_parent
    before_action :set_year, only: %i[generation_monthly capacity_yearly]

    ALLOWED_GROUPS = { grid_id: Grid }.freeze

    def generation_monthly; end
    def generation_yearly; end
    def capacity_yearly; end

    private

    def set_parent
      parent_id = ALLOWED_GROUPS.keys.detect { |key| params[key].present? }

      if parent_id
        model_class = ALLOWED_GROUPS[parent_id]
        @parent = model_class.friendly.find(params[parent_id])
      else
        render json: { error: "Resource not found" }, status: :not_found
      end
    end

    def set_year
      @year = params.permit(:year)[:year].presence&.to_i
    end
  end
end
