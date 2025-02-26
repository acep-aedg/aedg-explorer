# app/models/concerns/population_attributes.rb
module PopulationAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties)
      assign_attributes(
        total_population: properties['total_population'],
      )
    end
  end
end