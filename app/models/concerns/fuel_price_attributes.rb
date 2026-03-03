module FuelPriceAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!
      new.tap do |fuel_price|
        fuel_price.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        price: params[:price],
        fuel_type: params[:fuel_type],
        price_type: params[:price_type],
        source: params[:source],
        reporting_season: params[:reporting_season],
        reporting_year: params[:reporting_year]
      )
    end
  end
end
