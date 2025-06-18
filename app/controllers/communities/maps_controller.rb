module Communities
  class MapsController < ApplicationController
    before_action :set_community

    def house_districts
      geojson = Rails.cache.fetch(['community', @community.fips_code, 'house_districts'], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.house_districts.map(&:as_geojson)
        }
      end

      render json: geojson
    end

    def senate_districts
      geojson = Rails.cache.fetch(['community', @community.fips_code, 'senate_districts'], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.senate_districts.map(&:as_geojson)
        }
      end

      render json: geojson
    end

    private

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end
  end
end
