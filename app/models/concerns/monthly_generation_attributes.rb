# app/models/concerns/monthly_generation_attributes.rb
module MonthlyGenerationAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      MonthlyGeneration.new.tap do |monthly_generation|
        monthly_generation.assign_aedg_attributes(properties)
        monthly_generation.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        aea_plant_id: params[:aea_plant_id],
        eia_plant_id: params[:eia_plant_id],
        fuel_type_code: params[:fuel_type_code],
        fuel_type_name: params[:fuel_type_name],
        year: params[:year],
        month: params[:month],
        net_generation_mwh: params[:net_generation_mwh]
      )
    end
  end
end
