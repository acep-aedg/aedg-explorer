module Grids
  class MapsController < ApplicationController
    before_action :set_grid

    def community_locations
      geojson = Rails.cache.fetch(['maps', @grid.cache_key_with_version, @grid.communities.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @grid.communities.with_location.map do |c|
            feat = c.as_geojson
            feat[:properties][:path] = helpers.community_path(c)
            feat
          end
        }
      end

      render json: geojson
    end

    def service_area_geoms
      geojson = Rails.cache.fetch(['maps', @grid.cache_key_with_version, @grid.service_area_geoms.cache_key_with_version], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @grid.service_area_geoms.distinct.map(&:as_geojson)
        }
      end
      render json: geojson
    end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
