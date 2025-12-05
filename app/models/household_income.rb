class HouseholdIncome < ApplicationRecord
  include HouseholdIncomeAttributes
  validates :community_fips_code, presence: true
  belongs_to :community,
             foreign_key: :community_fips_code,
             primary_key: :fips_code,
             inverse_of: :household_incomes,
             optional: false,
             touch: true

  INCOME_BRACKET_FIELDS = %w[
    e_household_inc_under_10000
    e_household_inc_10000_14999
    e_household_inc_15000_24999
    e_household_inc_25000_34999
    e_household_inc_35000_49999
    e_household_inc_50000_74999
    e_household_inc_75000_99999
    e_household_inc_100000_149999
    e_household_inc_150000_199999
    e_household_inc_200000_plus
  ].freeze

  def self.stacked_income_series_for(rows)
    rows         = Array(rows)
    rows_by_year = rows.group_by { |r| r.end_year.to_i }

    INCOME_BRACKET_FIELDS.map do |col|
      {
        name: col,
        data: build_series_for_column(col, rows_by_year)
      }
    end
  end

  def self.build_series_for_column(col, rows_by_year)
    rows_by_year.map do |year, rows_for_year|
      total = rows_for_year.sum { |r| r.e_households_total.to_f }
      value = rows_for_year.sum { |r| r[col].to_f }

      percent =
        if total.zero?
          nil
        else
          ((value / total) * 100).round(2)
        end

      [year, percent]
    end.sort_by(&:first)
  end
end
