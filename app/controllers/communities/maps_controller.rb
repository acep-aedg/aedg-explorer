class Communities::MapsController < ApplicationController
  before_action :set_community

  def legislative_districts
    house_districts = @community.house_districts.uniq
    senate_districts = @community.senate_districts.uniq

    house_features = house_districts.map do |district|
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

    senate_features = senate_districts.map do |district|
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
      house: {
        type: "FeatureCollection",
        features: house_features
      },
      senate: {
        type: "FeatureCollection",
        features: senate_features
      }
    }
  end
  
  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private
    def set_community
        @community = Community.find(params[:community_id])
    end
end

