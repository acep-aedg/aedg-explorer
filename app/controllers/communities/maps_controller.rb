module Communities
  class MapsController < ApplicationController
    before_action :set_community

    def house_districts
      geojson = Rails.cache.fetch(["community", @community.id, "house_districts"], expires_in: 12.hours) do
        districts = @community.house_districts.distinct

        features = districts.map do |district|
          {
            type: "Feature",
            geometry: RGeo::GeoJSON.encode(district.boundary),
            properties: {
              id: district.district,
              name: district.name,
              tooltip: "House: #{district.district} - #{district.name}"
            }
          }
        end

        {
          type: "FeatureCollection",
          features: features
        }
      end

      render json: geojson
    end

    def senate_districts
      geojson = Rails.cache.fetch(["community", @community.id, "senate_districts"], expires_in: 12.hours) do
        districts = @community.senate_districts.distinct

        features = districts.map do |district|
          {
            type: "Feature",
            geometry: RGeo::GeoJSON.encode(district.boundary),
            properties: {
              id: district.district,
              tooltip: "Senate: #{district.district}"
            }
          }
        end

        {
          type: "FeatureCollection",
          features: features
        }
      end

      render json: geojson
    end

    private

    def set_community
      @community = Community.find(params[:community_id])
    end
  end
end
