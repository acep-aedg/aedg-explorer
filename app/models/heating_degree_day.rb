class HeatingDegreeDay < ApplicationRecord
  include HeatingDegreeDayAttributes

  validates :community_fips_code, presence: true
  belongs_to :community, foreign_key: :community_fips_code, primary_key: :fips_code, inverse_of: :heating_degree_days, optional: false, touch: true

  def self.data_by_year(owner, year)
    grouped = where(community: owner, year: year)
              .group(:month)
              .sum(:heating_degree_days)

    return {} if grouped.empty?

    (1..12).to_h do |m|
      [Date::ABBR_MONTHNAMES[m], grouped.fetch(m, 0)]
    end
  end
end
