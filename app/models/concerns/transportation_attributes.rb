# app/models/concerns/transportation_attributes.rb
module TransportationAttributes
  extend ActiveSupport::Concern

  included do
    def assign_aedg_attributes(properties)
      assign_attributes(
        airport: properties['airport'],
        harbor_dock: properties['harbor_dock'],
        state_ferry: properties['state_ferry'],
        cargo_barge: properties['cargo_barge'],
        road_connection: properties['road_connection'],
        coastal: properties['coastal'],
        road_or_ferry: properties['road_or_ferry'],
        description: properties['description'],
        as_of_date: properties['as_of_date']
      )
    end
  end
end