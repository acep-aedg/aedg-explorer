# app/models/concerns/yearly_generation_attributes.rb
module YearlyGenerationAttributes
  extend ActiveSupport::Concern

  class_methods do 
    def import_aedg!(properties)
      properties.symbolize_keys!

      YearlyGeneration.find_or_initialize_by(grid: Grid.from_aedg_id(properties[:grid_id]).first, year: properties[:year], fuel_type: properties[:fuel_type]).tap do |yearly_generation|
        yearly_generation.assign_aedg_attributes(properties)
        yearly_generation.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        net_generation_mwh: params[:net_generation_mwh]
      )
    end
  end
end