class Borough < ApplicationRecord
  include BoroughAttributes
  include Facetable
  include Displayable
  include Searchable
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  has_many :communities, foreign_key: :borough_fips_code, primary_key: :fips_code
  has_many :service_area_geoms, -> { distinct }, through: :communities
  has_many :plants, -> { distinct }, through: :service_area_geoms
  has_many :service_areas, -> { distinct }, through: :service_area_geoms
  has_many :capacities, -> { distinct }, through: :plants
  has_many :yearly_generations, -> { distinct }, through: :plants
  has_many :monthly_generations, -> { distinct }, through: :plants

  default_scope { order(name: :asc) }

  def to_s
    name
  end

  def boundary_map_layer
    "boroughs"
  end

  def should_generate_new_friendly_id?
    slug.nil? || name_changed?
  end

  def display_type
    @display_type ||= is_census_area? ? "Census Area" : "Borough"
  end

  def self.dropdown_label
    "Borough or Census Area"
  end

  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(boundary),
      properties: {
        id: id,
        title: name,
        category: is_census_area ? "Census Area" : "Borough",
        fips: fips_code
      }
    }
  end
end
