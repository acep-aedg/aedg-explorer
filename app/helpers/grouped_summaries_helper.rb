module GroupedSummariesHelper
  def grouped_summaries_registry
    {
      "Communities" => { icon: "bi-people-fill", path: communities_path },
      "Electric Grids" => { icon: "bi-lightning-charge-fill", path: grids_path },
      "House Districts" => { icon: "bi-house-fill", path: house_districts_path },
      "Senate Districts" => { icon: "bi-map-fill", path: senate_districts_path }
    }
  end

  def summary_icon_for(model_collection)
    name = model_collection.model_name.human.pluralize.titleize
    grouped_summaries_registry.dig(name, :icon) || "bi-grid-fill"
  end

  def show_search_letters?(collection)
    return false if collection.try(:model) == SenateDistrict

    true
  end
end
