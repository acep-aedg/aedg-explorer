module Communities
  class MapsController < ApplicationController
    before_action :set_community

    def house_districts
      geojson = Rails.cache.fetch(["community", @community.fips_code, "house_districts"], expires_in: 12.hours) do
        HouseDistrict.as_geojson(@community.house_districts.distinct)
      end

      render json: geojson
    end

    def senate_districts
      geojson = Rails.cache.fetch(["community", @community.fips_code, "senate_districts"], expires_in: 12.hours) do
        SenateDistrict.as_geojson(@community.senate_districts.distinct)
      end

      render json: geojson
    end

    private

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end
  end
end
