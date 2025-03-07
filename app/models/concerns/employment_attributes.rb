module EmploymentAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      Employment.build.tap do |employment|
        employment.assign_aedg_attributes(properties)
        employment.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        residents_employed: params[:residentsemployed],
        unemployment_insurance_claimants: params[:unemploymentinsuranceclaimants],
        measurement_year: params[:measurement_year]
      )
    end
  end
end
