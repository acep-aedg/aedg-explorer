class Communities::MapsController < ApplicationController
  before_action :set_community

  def house_districts
    features = @community.house_districts.map do |district|
      {
        type: "Feature",
        geometry: RGeo::GeoJSON.encode(district.boundary),
        properties: {
          id: district.district,
          name: district.name,
          tooltip: "District #{district.district}: #{district.name}"
        }
      }
    end

    geojson = {
      type: "FeatureCollection",
      features: features
    }
    pp geojson

    render json: geojson
  end

  def senate_districts
    districts = @community.senate_districts.map do |district|
      {
        geometry: RGeo::GeoJSON.encode(district.boundary),
        label: "District #{district.district}",
        tooltip: "Disctrict #{district.district}"
      }
    end

    render json: districts
  end  
  
  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private
    def set_community
        @community = Community.find(params[:community_id])
    end
end

