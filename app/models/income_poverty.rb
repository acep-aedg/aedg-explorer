class IncomePoverty < ApplicationRecord
  include IncomePovertyAttributes

  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :income_poverties, optional: false, touch: true

  def self.show_per_capita_income_chart?
    where("e_per_capita_income > 0").exists?
  end

  def self.show_poverty_chart?
    where("e_pop_below_poverty > 0 AND e_pop_of_poverty_det > 0").exists?
  end
end
