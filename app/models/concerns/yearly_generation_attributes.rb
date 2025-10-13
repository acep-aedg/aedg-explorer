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
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        year: params[:year],
        fuel_type_code: params[:fuel_type_code],
        fuel_type_name: params[:fuel_type_name],
        net_generation_mwh: params[:net_generation_mwh]
      )
    end
  end
end
