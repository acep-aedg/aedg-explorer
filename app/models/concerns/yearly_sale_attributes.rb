module YearlySaleAttributes
  extend ActiveSupport::Concern

  class_methods do
    def build_from_aedg(properties)
      properties.symbolize_keys!

      new.tap do |sale|
        sale.assign_aedg_attributes(properties)
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        reporting_entity: ReportingEntity.from_aedg_id(params[:reporting_entity_id]).first,
        year: params[:year],
        residential_revenue: params[:residential_revenue],
        residential_sales: params[:residential_sales],
        residential_customers: params[:residential_customers],
        commercial_revenue: params[:commercial_revenue],
        commercial_sales: params[:commercial_sales],
        commercial_customers: params[:commercial_customers],
        industrial_revenue: params[:industrial_revenue],
        industrial_sales: params[:industrial_sales],
        industrial_customers: params[:industrial_customers],
        transportation_revenue: params[:transportation_revenue],
        transportation_sales: params[:transportation_sales],
        transportation_customers: params[:transportation_customers],
        community_revenue: params[:community_revenue],
        community_sales: params[:community_sales],
        community_customers: params[:community_customers],
        government_sales: params[:government_sales],
        government_customers: params[:government_customers],
        unbilled_sales: params[:unbilled_sales],
        unbilled_customers: params[:unbilled_customers],
        other_revenue: params[:other_revenue],
        other_sales: params[:other_sales],
        other_customers: params[:other_customers],
        total_revenue: params[:total_revenue],
        total_sales: params[:total_sales],
        total_customers: params[:total_customers],
        source: params[:source]
      )
    end
  end
end
