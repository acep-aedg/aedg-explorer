module HeatingDegreeDayAttributes
  extend ActiveSupport::Concern

  class_methods do
    def import_aedg!(properties)
      properties.symbolize_keys!

      HeatingDegreeDay.new.tap do |hdd|
        hdd.assign_aedg_attributes(properties)
        hdd.save!
      end
    end
  end

  included do
    def assign_aedg_attributes(params)
      assign_attributes(
        community_fips_code: params[:community_fips_code],
        year: params[:year],
        days: params[:hdd]
      )
    end
  end
end
