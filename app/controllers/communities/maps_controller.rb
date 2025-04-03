class Communities::MapsController < ApplicationController
  before_action :set_community

  def house_districts
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

    render json: {
      type: "FeatureCollection",
      features: features
    }
  end

  def senate_districts
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

    render json: {
      type: "FeatureCollection",
      features: features
    }
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end