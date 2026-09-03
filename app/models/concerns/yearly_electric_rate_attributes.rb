# app/models/concerns/electric_rate_attributes.rb
module YearlyElectricRateAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!
      new.tap do |electric_rate|
        electric_rate.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        reporting_entity: ReportingEntity.from_aedg_id(params[:reporting_entity_id]).first,
        year: params[:year],
        residential_rate: params[:residential_rate],
        residential_rate_subsidized: params[:residential_rate_subsidized],
        commercial_rate: params[:commercial_rate],
        industrial_rate: params[:industrial_rate],
        transportation_rate: params[:transportation_rate],
        community_rate: params[:community_rate],
        other_rate: params[:other_rate],
        total_rate: params[:total_rate],
        source: params[:source]
      )
    end
  end
end
