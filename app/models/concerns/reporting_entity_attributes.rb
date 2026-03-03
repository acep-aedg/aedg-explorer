# app/models/concerns/reporting_entity_attributes.rb
module ReportingEntityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!

      raise "id is required" if properties[:id].nil?

      new.tap do |entity|
        entity.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        name: params[:name],
        most_recent_year: params[:most_recent_year],
        aedg_import_attributes: { aedg_id: params[:id] },
        grid: Grid.from_aedg_id(params[:grid_id]).first
      )
    end
  end
end
