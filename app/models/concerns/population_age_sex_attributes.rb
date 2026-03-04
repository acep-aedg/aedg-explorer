# app/models/concerns/population_age_sex_attributes.rb
module PopulationAgeSexAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!
      new.tap do |pop_age_sex|
        pop_age_sex.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(params)
    end
  end
end
