# app/models/concerns/community_grid_attributes.rb
module CommunityGridAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      CommunityGrid.new.tap do |cg|
        cg.assign_aedg_attributes(properties)
        cg.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        connection_year: params[:connection_year],
        termination_year: params[:termination_year],
        grid: Grid.from_aedg_id(params[:grid_id]).first
      )
    end
  end
end
