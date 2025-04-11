# app/models/concerns/yearly_generation_attributes.rb
module YearlyGenerationAttributes
  extend ActiveSupport::Concern

  class_methods do 
    def import_aedg!(properties)
      properties.symbolize_keys!

      YearlyGeneration.new.tap do |yearly_generation|
        yearly_generation.assign_aedg_attributes(properties)
        yearly_generation.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        grid: Grid.from_aedg_id(params[:grid_id]).first,
        year: params[:year],
        fuel_type: params[:fuel_type],
        net_generation_mwh: params[:net_generation_mwh]
      )
    end
  end
end