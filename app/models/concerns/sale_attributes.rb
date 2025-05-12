module SaleAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      Sale.new.tap do |sale|
        sale.assign_aedg_attributes(properties)
        sale.save!
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
        total_revenue: params[:total_revenue],
        total_sales: params[:total_sales],
        total_customers: params[:total_customers]
      )
    end
  end
end
