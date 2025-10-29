module Communities
  class MapsController < ApplicationController
    before_action :set_community

    def house_districts
      geojson = Rails.cache.fetch(['maps', @community.cache_key_with_version, @community.house_districts.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.house_districts.map(&:as_geojson)
        }
      end

      render json: geojson
    end

    def senate_districts
      geojson = Rails.cache.fetch(['maps', @community.cache_key_with_version, @community.senate_districts.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.senate_districts.map(&:as_geojson)
        }
      end

      render json: geojson
    end

    def service_area_geoms
      geojson = Rails.cache.fetch(['maps', @community.cache_key_with_version, @community.service_area_geoms.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.service_area_geoms.map(&:as_geojson)
        }
      end
      render json: geojson
    end

    def service_areas
      geojson = Rails.cache.fetch(['maps', @community.cache_key_with_version, @community.service_areas.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.service_areas.map(&:as_geojson)
        }
      end
      render json: geojson
    end

    def plants
      geojson = Rails.cache.fetch(['maps', @community.cache_key_with_version, @community.plants.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.plants.map(&:as_geojson)
        }
      end
      render json: geojson
    end

    def bulk_fuel_facilities
      geojson = Rails.cache.fetch(['maps', @community.cache_key_with_version, 'bulk_fuel_facilities'], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @community.bulk_fuel_facilities.map(&:as_geojson)
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
