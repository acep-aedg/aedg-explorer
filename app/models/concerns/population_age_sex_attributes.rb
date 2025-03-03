# app/models/concerns/population_age_sex_attributes.rb
module PopulationAgeSexAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties)
      assign_attributes(
        start_year: properties['start_year'],
        end_year: properties['end_year'],
        is_most_recent: properties['is_most_recent'],
        geo_src: properties['geo_src'],
        e_pop_age_total: properties['e_pop_age_total'],
        m_pop_age_total: properties['m_pop_age_total'],
        e_pop_age_under_5: properties['e_pop_age_under_5'],
        m_pop_age_under_5: properties['m_pop_age_under_5'],
        e_pop_age_5_9: properties['e_pop_age_5_9'],
        m_pop_age_5_9: properties['m_pop_age_5_9'],
        e_pop_age_10_14: properties['e_pop_age_10_14'],
        m_pop_age_10_14: properties['m_pop_age_10_14'],
        e_pop_age_15_19: properties['e_pop_age_15_19'],
        m_pop_age_15_19: properties['m_pop_age_15_19'],
        e_pop_age_20_24: properties['e_pop_age_20_24'],
        m_pop_age_20_24: properties['m_pop_age_20_24'],
        e_pop_age_25_34: properties['e_pop_age_25_34'],
        m_pop_age_25_34: properties['m_pop_age_25_34'],
        e_pop_age_35_44: properties['e_pop_age_35_44'],
        m_pop_age_35_44: properties['m_pop_age_35_44'],
        e_pop_age_45_54: properties['e_pop_age_45_54'],
        m_pop_age_45_54: properties['m_pop_age_45_54'],
        e_pop_age_55_59: properties['e_pop_age_55_59'],
        m_pop_age_55_59: properties['m_pop_age_55_59'],
        e_pop_age_60_64: properties['e_pop_age_60_64'],
        m_pop_age_60_64: properties['m_pop_age_60_64'],
        e_pop_age_65_74: properties['e_pop_age_65_74'],
        m_pop_age_65_74: properties['m_pop_age_65_74'],
        e_pop_age_75_84: properties['e_pop_age_75_84'],
        m_pop_age_75_84: properties['m_pop_age_75_84'],
        e_pop_age_85_plus: properties['e_pop_age_85_plus'],
        m_pop_age_85_plus: properties['m_pop_age_85_plus'],
        e_pop_age_median_age: properties['e_pop_age_median_age'],
        m_pop_age_median_age: properties['m_pop_age_median_age'],
        e_pop_age_under_18: properties['e_pop_age_under_18'],
        m_pop_age_under_18: properties['m_pop_age_under_18'],
        e_pop_age_18_plus: properties['e_pop_age_18_plus'],
        m_pop_age_18_plus: properties['m_pop_age_18_plus'],
        e_pop_age_21_plus: properties['e_pop_age_21_plus'],
        m_pop_age_21_plus: properties['m_pop_age_21_plus'],
        e_pop_age_62_plus: properties['e_pop_age_62_plus'],
        m_pop_age_62_plus: properties['m_pop_age_62_plus'],
        e_pop_age_65_plus: properties['e_pop_age_65_plus'],
        m_pop_age_65_plus: properties['m_pop_age_65_plus'],
        e_pop_total: properties['e_pop_total'],
        m_pop_total: properties['m_pop_total'],
        e_pop_male: properties['e_pop_male'],
        m_pop_male: properties['m_pop_male'],
        e_pop_female: properties['e_pop_female'],
        m_pop_female: properties['m_pop_female']
      )
    end
  end
end