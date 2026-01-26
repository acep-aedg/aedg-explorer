class SchoolDistrict < ApplicationRecord
  include SchoolDistrictAttributes

  has_many :communities_school_districts, dependent: :destroy
  has_many :communities, through: :communities_school_districts

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]
  validates :district, presence: true, uniqueness: true

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: district,
        tooltip: "School District: #{district}"
      }
    }
  end

  def formatted_type
    return "" if district_type.blank?

    # Only fix if it's CamelCase with no spaces
    if district_type.match?(/\A[A-Z][a-z]+(?:[A-Z][a-z]+)+\z/)
      district_type.underscore.titleize
    else
      district_type
    end
  end
end
