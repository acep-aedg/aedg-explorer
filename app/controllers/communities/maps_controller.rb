class Communities::MapsController < ApplicationController
  before_action :set_community

  def house_districts
    geojson = Rails.cache.fetch(["community", @community.id, "house_districts"], expires_in: 12.hours) do
      Rails.logger.info "[CACHE MISS] House districts for community #{@community.id}"

      districts = @community.house_districts.distinct

      features = districts.map do |district|
        {
          type: "Feature",
          geometry: RGeo::GeoJSON.encode(district.boundary),
          properties: {
            id: district.district,
            name: district.name,
            tooltip: "House: #{district.district} - #{district.name}",
            layer: "house"
          }
        }
      end

      {
        type: "FeatureCollection",
        features: features
      }
    end

    Rails.logger.info "[CACHE HIT] House districts for community #{@community.id}"

    render json: geojson
  end

  def senate_districts
    geojson = Rails.cache.fetch(["community", @community.id, "senate_districts"], expires_in: 12.hours) do
      Rails.logger.info "[CACHE MISS] Senate districts for community #{@community.id}"

      districts = @community.senate_districts.distinct

      features = districts.map do |district|
        {
          type: "Feature",
          geometry: RGeo::GeoJSON.encode(district.boundary),
          properties: {
            id: district.district,
            tooltip: "Senate: #{district.district}",
            layer: "senate"
          }
        }
      end

      {
        type: "FeatureCollection",
        features: features
      }
    end

    Rails.logger.info "[CACHE HIT] Senate districts for community #{@community.id}"

    render json: geojson
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end