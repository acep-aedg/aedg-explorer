class Employment < ApplicationRecord
  include EmploymentAttributes
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :communities, foreign_key: "community_fips_code", primary_key: "fips_code"

  validates :fips_code, presence: true, uniqueness: true
end
