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
        fuel_type: params[:fuel_type],
        year: params[:year],
        month: params[:month],
        net_generation_mwh: params[:net_generation_mwh],
        grid: Grid.from_aedg_id(params[:grid_id]).first
      )
    end
  end
end