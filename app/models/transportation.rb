class Transportation < ApplicationRecord
  include TransportationAttributes
  belongs_to :community, foreign_key: "community_fips_code", primary_key: "fips_code"
  validates :community_fips_code, presence: true, uniqueness: true

  TRANSPORT_FIELDS = %w[airport harbor_dock state_ferry cargo_barge road_connection coastal]
end
