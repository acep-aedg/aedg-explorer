module ModalHelper
  def generation_modal_partials(entity)
    partials = [
      "shared/modal/data_reporting",
      "shared/modal/net_vs_gross_generation",
      "shared/modal/ipp_generation"
    ]

    case entity
    when Grid
      partials.unshift("shared/modal/grid_plant_connection")
    when SenateDistrict, HouseDistrict
      partials.unshift("shared/modal/power_generation_sources")
    end

    partials
  end

  def capacity_modal_partials(entity)
    partials = [
      "shared/modal/ipp_generation"
    ]

    case entity
    when Grid
      partials.unshift("shared/modal/grid_plant_connection")
    when SenateDistrict, HouseDistrict
      partials.unshift("shared/modal/power_generation_sources")
    end

    partials
  end

  def service_area_text(entity)
    count = entity.respond_to?(:service_areas) ? entity.service_areas.distinct.count(:cpcn_id) : 1

    label = entity.local_service_area? ? 'local service area' : 'utility service area'
    verb = (count == 1) ? "serves" : "serve"

    "#{label.pluralize(count)} that #{verb} this #{entity.class.model_name.human.downcase}"
  end
end
