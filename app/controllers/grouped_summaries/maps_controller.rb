module GroupedSummaries
  class MapsController < ApplicationController
    before_action :set_parent

    ALLOWED_GROUPS = { grid_id: Grid }.freeze

    def community_locations; end
    def service_areas; end
    def plants; end

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
  end
end
