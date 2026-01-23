# app/models/concerns/reporting_entity_attributes.rb
module ReportingEntityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      raise 'id is required' if properties[:id].nil?

      ReportingEntity.create!(
        aedg_id: properties[:id],
        most_recent_year: properties[:most_recent_year],
        name: properties[:name],
        grid: Grid.from_aedg_id(properties[:grid_id]).first
      )
    end
  end
end
