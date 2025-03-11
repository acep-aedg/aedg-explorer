module HouseDistrictAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_geojson_feature!(properties, geometry)
      properties.symbolize_keys!

      house = HouseDistrict.find_or_initialize_by(house_district: properties[:district])

      house.assign_attributes(
        name: properties[:name],
        as_of_date: properties[:as_of_date],
        geometry: geometry
      )

      house.save!
    end
  end
end
