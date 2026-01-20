module CommunitiesReportingEntityAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      CommunitiesReportingEntity.new.tap do |communities_reporting_entity|
        communities_reporting_entity.assign_aedg_attributes(properties)
        communities_reporting_entity.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        reporting_entity: ReportingEntity.from_aedg_id(params[:reporting_entity_id]).first
      )
    end
  end
end
