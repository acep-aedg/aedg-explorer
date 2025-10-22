module Grids
  class MapsController < ApplicationController
    before_action :set_grid

    def community_locations
      geojson = Rails.cache.fetch(['grid', @grid.id, 'community_locations'], expires_in: 12.hours) do
        {
          type: 'FeatureCollection',
          features: @grid.communities.with_location.map(&:as_geojson)
        }
      end
      render json: geojson
    end

    def service_area_geoms
      geojson = Rails.cache.fetch(['grid', @grid.id, 'service_area_geoms'], expires_in: 12.hours) do
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
