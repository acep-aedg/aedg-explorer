# app/models/concerns/population_age_sex_attributes.rb
module PopulationAgeSexAttributes
  extend ActiveSupport::Concern

  class_methods do 
    def import_aedg!(properties)
      properties.symbolize_keys!

      PopulationAgeSex.find_or_initialize_by(community_fips_code: properties[:community_fips_code],start_year: properties[:start_year], end_year: properties[:end_year], geo_src: properties[:geo_src]).tap do |pop_age_sex|
        pop_age_sex.assign_aedg_attributes(properties)
        pop_age_sex.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(params)
    end
  end
end