# app/models/concerns/household_income_attributes.rb
module HouseholdIncomeAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      HouseholdIncome.new.tap do |income|
        income.assign_aedg_attributes(properties)
        income.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        # rubocop:disable Naming/VariableNumber
        community_fips_code: params[:community_fips_code],
        e_households_total: params[:e_households_total],
        e_household_median_income: params[:e_household_median_income],
        e_household_inc_under_10000: params[:e_household_inc_under_10000],
        e_household_inc_10000_14999: params[:e_household_inc_10000_14999],
        e_household_inc_15000_24999: params[:e_household_inc_15000_24999],
        e_household_inc_25000_34999: params[:e_household_inc_25000_34999],
        e_household_inc_35000_49999: params[:e_household_inc_35000_49999],
        e_household_inc_50000_74999: params[:e_household_inc_50000_74999],
        e_household_inc_75000_99999: params[:e_household_inc_75000_99999],
        e_household_inc_100000_149999: params[:e_household_inc_100000_149999],
        e_household_inc_150000_199999: params[:e_household_inc_150000_199999],
        e_household_inc_200000_plus: params[:e_household_inc_200000_plus],
        start_year: params[:start_year],
        end_year: params[:end_year]
        # rubocop:enable Naming/VariableNumber

      )
    end
  end
end
