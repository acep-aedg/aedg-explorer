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
          { name: "Electric Grids", path: grids_path },
          { name: "View More", path: explore_all_path }
        ] },
      { name: "User Guide", path: user_guide_path }
    ]
  end

  def page_title(parents, parent = nil)
    if parent.present?
      [parents.model_name.human.titleize, parent.to_s].compact.join(" - ")
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

  def map_layer_checkbox(id:, label:, path_args:)
    content_tag(:div, class: "form-check d-flex align-items-center mb-1") do
      concat check_box_tag(id, nil, false,
                           class: "form-check-input",
                           data: { action: "change->maps#toggleLayer", url: polymorphic_path(path_args), fit: true })

      label_content = content_tag(:span, nil, class: "legend-swatch me-2", data: { maps_target: "swatch" }) + label
      concat label_tag(id, label_content, class: "form-check-label small ms-2")
    end
  end

  def search_placeholder_for(model)
    name = model.model_name.human.titleize.pluralize

    if model == Community
      "Search #{name} by name, electric grid or house district..."
    else
      "Search #{name} by name or community..."
    end
  end
end
