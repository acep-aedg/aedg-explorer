# app/models/concerns/reporting_entity_attributes.rb
module ReportingEntityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      raise 'id is required' if properties[:id].nil?

      ReportingEntity.create!(
        aedg_id: properties[:id],
        year: properties[:year],
        utility_name: properties[:utility_name],
        grid: Grid.from_aedg_id(properties[:grid_id]).first
      )
    end
  end
end
