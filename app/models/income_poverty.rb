class IncomePoverty < ApplicationRecord
  include IncomePovertyAttributes

  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :income_poverties, optional: false, touch: true

  def self.show_per_capita_income_chart?
    where("e_per_capita_income > 0").exists?
  end
end
