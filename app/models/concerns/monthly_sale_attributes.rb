module MonthlySaleAttributes
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
        month: params[:month],
        residential_revenue: params[:residential_revenue],
        residential_sales_mwh: params[:residential_sales_mwh],
        residential_customers: params[:residential_customers],
        commercial_revenue: params[:commercial_revenue],
        commercial_sales_mwh: params[:commercial_sales_mwh],
        commercial_customers: params[:commercial_customers],
        industrial_revenue: params[:industrial_revenue],
        industrial_sales_mwh: params[:industrial_sales_mwh],
        industrial_customers: params[:industrial_customers],
        transportation_revenue: params[:transportation_revenue],
        transportation_sales_mwh: params[:transportation_sales_mwh],
        transportation_customers: params[:transportation_customers],
        community_revenue: params[:community_revenue],
        community_sales_mwh: params[:community_sales_mwh],
        community_customers: params[:community_customers],
        government_sales_mwh: params[:government_sales_mwh],
        government_customers: params[:government_customers],
        unbilled_sales_mwh: params[:unbilled_sales_mwh],
        unbilled_customers: params[:unbilled_customers],
        other_revenue: params[:other_revenue],
        other_sales_mwh: params[:other_sales_mwh],
        other_customers: params[:other_customers],
        total_revenue: params[:total_revenue],
        total_sales_mwh: params[:total_sales_mwh],
        total_customers: params[:total_customers],
        source: params[:source]
      )
    end
  end
end
