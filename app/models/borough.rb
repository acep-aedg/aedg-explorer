class Borough < ApplicationRecord
  include BoroughAttributes
  include Facetable
  has_many :communities, foreign_key: "borough_fips_code", primary_key: "fips_code"

  validates :fips_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :boundary, presence: true, allowed_geometry_types: %w[Polygon MultiPolygon]

  default_scope { order(name: :asc) }

  # Census Areas are apart of the Unorganized Borough
  def census_area?
    name&.match?(/\bcensus\b/i)
  end
end
