class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  include Facetable
  include Displayable
  include Searchable
  extend FriendlyId

  friendly_id :district, use: :slugged
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  has_many :communities_house_districts, foreign_key: :house_district_district, primary_key: :district, dependent: :destroy, inverse_of: :house_district
  has_many :communities, through: :communities_house_districts
  has_many :reporting_entities, -> { distinct }, through: :communities
  has_many :service_area_geoms, -> { distinct }, through: :communities
  has_many :plants, -> { distinct }, through: :service_area_geoms
  has_many :service_areas, -> { distinct }, through: :service_area_geoms
  has_many :capacities, -> { distinct }, through: :plants
  has_many :yearly_generations, -> { distinct }, through: :plants
  has_many :monthly_generations, -> { distinct }, through: :plants

  def to_s
    "#{district} - #{name}"
  end

  def boundary_map_layer
    "house-districts"
  end

  def long_name
    "#{self.class.model_name.human.titleize} #{self}"
  end

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: id,                 # Database bigint ID
        district: district,     # The number/code (e.g., "36")
        name: name,             # The name (e.g., "Copper River Basin")
        category: "House District Area", # Static label for the popup header
        as_of: as_of_date # Metadata to show later
      }
    }
  end
end
