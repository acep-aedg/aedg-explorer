module Communities
  class MapsController < ApplicationController
    before_action :set_community

    def house_districts; end
    def senate_districts; end
    def service_area_geoms; end
    def service_areas; end
    def plants; end
    def bulk_fuel_facilities; end

    private

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end
  end
end
