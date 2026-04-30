module GroupedSummaries
  class MapsController < ApplicationController
    before_action :set_parent

    ALLOWED_GROUPS = {
      grid_id: Grid,
      house_district_id: HouseDistrict,
      senate_district_id: SenateDistrict,
      regional_corporation_id: RegionalCorporation,
      borough_id: Borough
    }.freeze

    def community_locations; end
    def service_areas; end
    def service_area_geoms; end
    def plants; end
    def boundary; end

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
