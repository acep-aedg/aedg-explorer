class RegionalCorporation < ApplicationRecord
  include RegionalCorporationAttributes
  include Facetable
  include Displayable
  include Searchable
  extend FriendlyId

  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    slug.nil? || name_changed?
  end

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  has_many :communities, foreign_key: :regional_corporation_fips_code, primary_key: :fips_code
  has_many :reporting_entities, through: :communities
  has_many :service_area_geoms,
           lambda { |reg_corp|
             unscope(:where).where(
               "ST_Intersects(
                   service_area_geoms.boundary,
                   (SELECT boundary FROM regional_corporations WHERE id = ?)
                 )",
               reg_corp.id
             )
           },
           dependent: :nullify,
           inverse_of: false
  has_many :plants, through: :service_area_geoms
  has_many :service_areas, -> { distinct }, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  default_scope { order(name: :asc) }

  def to_s
    name
  end

  def boundary_map_layer
    "layer-regional-corporation"
  end

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: id,
        name: name,
        land_area: land_area,
        water_area: water_area
      }
    }
  end
end
