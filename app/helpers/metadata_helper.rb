module MetadataHelper
  def topic_icon(topic_name)
    case topic_name.downcase
    when "energy"         then "bi-lightning-charge" # "⚡"
    when "social"         then "bi-people"           # "👥"
    when "transportation" then "bi-truck"            # "🚗"
    when "technology"     then "bi-cpu"              # "💻"
    when "geography"      then "bi-globe"            # "🌍"
    when "data models"    then "bi-database"         # "📊"
    else "bi-tag"
    end
  end
end
