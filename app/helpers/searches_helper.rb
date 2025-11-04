module SearchesHelper
  def param_array(key)
    Array(params[key]).reject(&:blank?).map(&:to_s)
  end

  # Determine whether a value should be checked in a facet checkbox
  def facet_checked?(param_key, value)
    param_array(param_key).include?(value.to_s)
  end

  # Returns true if any hidden facet options are selected
  def any_hidden_selected?(param_key, hidden_items, &value_of)
    hidden_items.any? { |item| facet_checked?(param_key, value_of.call(item)) }
  end

  # Return all selected items for a given list of available items
  # Example: selected_labels(@all_grids, :grid_ids) { |g| g.id }
  def selected_labels(items, param_key)
    ids = param_array(param_key)
    items.select { |item| ids.include?(yield(item).to_s) }
  end

  # Unified district label:
  # - House: "5 – Fairbanks North" (if name present), else "5"
  # - Senate: "A" (just district)
  def district_label(record)
    # Prefer explicit fields if available
    dist = record.try(:district) || record.try(:name) || record.try(:id)
    return dist unless record.respond_to?(:name)

    record.name.present? ? "#{dist} – #{record.name}" : dist
  end
end
