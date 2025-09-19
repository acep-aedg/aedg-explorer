module Grids
  class MapsController < ApplicationController
    before_action :set_grid

    def community_locations
      features = @grid.communities.with_location.map do |c|
        {
          type: 'Feature',
          properties: {
            tooltip: c.name
          },
          geometry: {
            type: 'Point',
            coordinates: [c.location.longitude.to_f, c.location.latitude.to_f]
          }
        }
      end

      render json: {
        type: 'FeatureCollection',
        features: features
      }
    end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
