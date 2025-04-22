# app/models/concerns/population_attributes.rb
module PopulationAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      Population.new.tap do |population|
        population.assign_aedg_attributes(properties)
        population.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        total_population: params[:total_population],
        year: params[:year]
      )
    end
  end
end
