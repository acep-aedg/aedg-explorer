# app/models/concerns/electric_rate_attributes.rb
module ElectricRateAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      ElectricRate.new.tap do |electric_rate|
        electric_rate.assign_aedg_attributes(properties)
        electric_rate.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        reporting_entity: ReportingEntity.from_aedg_id(params[:reporting_entity_id]).first,
        year: params[:year],
        residential_rate: params[:residential_rate],
        commercial_rate: params[:commercial_rate],
        industrial_rate: params[:industrial_rate]
      )
    end
  end
end
