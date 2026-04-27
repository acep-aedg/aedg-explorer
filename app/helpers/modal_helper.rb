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
    when SenateDistrict, HouseDistrict, RegionalCorporation
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
    when SenateDistrict, HouseDistrict, RegionalCorporation
      partials.unshift("shared/modal/power_generation_sources")
    end

    partials
  end

  def service_area_text(entity)
    service_areas = entity.respond_to?(:service_areas) ? entity.service_areas.to_a.uniq(&:cpcn_id) : []
    count = service_areas.any? ? service_areas.size : 1
    label_base = entity.local_service_area? ? "local service area" : "utility service area"

    {
      label: label_base.pluralize(count),
      count: count
    }
  end
end
