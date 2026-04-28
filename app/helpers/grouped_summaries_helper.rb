module GroupedSummariesHelper
  def grouped_summaries_registry
    {
      "Communities" => { icon: "bi-people-fill", path: communities_path },
      "Electric Grids" => { icon: "bi-lightning-charge-fill", path: grids_path },
      "House Districts" => { icon: "bi-house-fill", path: house_districts_path },
      "Senate Districts" => { icon: "bi-map-fill", path: senate_districts_path },
      "Regional Corporations" => { icon: "bi-building-fill", path: regional_corporations_path },
      "Boroughs & Census Areas" => { icon: "bi-bounding-box-circles", path: boroughs_path }
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

  def dropdown_prompt_for(collection)
    klass = collection.try(:klass)
    name = if klass.respond_to?(:dropdown_label)
             klass.dropdown_label
           elsif klass
             klass.model_name.human.titleize
           else
             "Item"
           end

    article = name.start_with?(/[aeiou]/i) ? "an" : "a"

    "Select #{article} #{name}"
  end
end
