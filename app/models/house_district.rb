class HouseDistrict < ApplicationRecord
  include HouseDistrictAttributes
  include Facetable
  include Displayable
  include Searchable
  extend FriendlyId

  friendly_id :district, use: :slugged

  has_many :communities_house_districts, foreign_key: :house_district_district, primary_key: :district, dependent: :destroy, inverse_of: :house_district
  has_many :communities, through: :communities_house_districts
  has_many :reporting_entities, through: :communities
  # has_many :service_area_geoms,
  #          lambda { |district|
  #            unscope(:where).where(
  #              "ST_Intersects(
  #                  service_area_geoms.boundary,
  #                  (SELECT boundary FROM house_districts WHERE id = ?)
  #                )",
  #              district.id
  #            )
  #          },
  #          dependent: :nullify,
  #          inverse_of: false
  has_many :service_area_geoms,
           lambda { |district|
             unscope(:where).where(
               "service_area_geoms.boundary && :bounds AND ST_Intersects(service_area_geoms.boundary, :bounds)",
               bounds: district.boundary
             )
           },
           dependent: :nullify,
           inverse_of: false
  has_many :plants, through: :service_area_geoms
  has_many :service_areas, -> { distinct }, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

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
