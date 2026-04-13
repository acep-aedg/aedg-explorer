module ApplicationHelper
  def google_analytics_id
    ENV.fetch("GOOGLE_ANALYTICS_ID", nil)
  end

  def main_menu
    [
      { name: "About", path: about_path },
      { name: "Explore Data",
        children: [
          { name: "Communities", path: communities_path },
          { name: "Data Explorer", path: metadata_path },
          { name: "Electric Grids", path: grids_path }
        ] },
      { name: "User Guide", path: user_guide_path }
    ]
  end

  def page_title(parents, parent = nil)
    if parent.present?
      [parents.model_name.human.titleize, parent&.name].compact.join(" - ")
    else
      "#{parents.model_name.human.titleize} Explorer"
    end
  end

  def mapbox_api_data(data)
    data["controller"] ||= "maps"
    data["maps_token_value"] ||= Rails.application.credentials.mapbox_api_token

    data
  end

  def markdownify(text)
    html = Kramdown::Document.new(text, input: "GFM").to_html

    scrubber = Rails::Html::PermitScrubber.new
    scrubber.tags = %w[a p br ul ol li strong em blockquote code pre h1 h2 h3 h4 h5 h6]
    scrubber.attributes = %w[href target rel title]

    sanitize(html, scrubber: scrubber)
  end

  # for loading Data... feature on UI when importing
  def import_status_message
    ::Kredis.string("aedg:import_status").value.presence
  end
end
