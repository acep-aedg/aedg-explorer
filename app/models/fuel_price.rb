class FuelPrice < ApplicationRecord
  include FuelPriceAttributes
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :fuel_prices

  scope :chronological, -> { order(:reporting_year, :reporting_season) }
end
