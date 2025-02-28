# app/models/concerns/yearly_generation_attributes.rb
module YearlyGenerationAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties)
      assign_attributes(
        grid: Grid.from_aedg_id(properties['grid_id']).first,
        net_generation_mwh: properties['net_generation_mwh'],
        fuel_type: properties['fuel_type'],
        year: properties['year']
      )
    end
  end
end