module ApplicationHelper
  def main_menu
    [
      { name: 'About', path: about_path },
      { name: 'Explore Data',
        children: [
          { name: 'Community Summaries', path: communities_path },
          { name: 'Data Explorer', path: metadata_path }
        ] },
      { name: 'User Guide', path: user_guide_path }
    ]
  end

  def mapbox_api_data(data)
    data['controller'] ||= 'maps'
    data['maps_token_value'] ||= Rails.application.credentials.mapbox_api_token

    data
  end
end
