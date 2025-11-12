# app/models/concerns/income_poverty_attributes.rb
module IncomePovertyAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      IncomePoverty.new.tap do |income_poverty|
        income_poverty.assign_aedg_attributes(properties)
        income_poverty.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        e_per_capita_income: params[:e_per_capita_income],
        m_per_capita_income: params[:m_per_capita_income],
        e_pop_below_poverty: params[:e_pop_below_poverty],
        m_pop_below_poverty: params[:m_pop_below_poverty],
        e_pop_of_poverty_det: params[:e_pop_of_poverty_det],
        m_pop_of_poverty_det: params[:m_pop_of_poverty_det],
        start_year: params[:start_year],
        end_year: params[:end_year]
      )
    end
  end
end
