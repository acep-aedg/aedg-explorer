module FooterHelper
  include ActionView::Helpers::UrlHelper

  def footer_links
    [
      { name: 'About AEDG', path: about_path, title: 'About AEDG' },
      { name: 'User Guide', path: user_guide_path, title: 'User Guide' }
    ]
  end

  def footer_about_title
    'About AEDG'
  end

  def footer_about_text
    "The Alaska Energy Data Gateway is a public resource funded by grants from the Alaska Energy Authority as well as the U.S. Department of Energy’s EPSCoR program and #{link_to 'Grid Modernization Initiative',
                                                                                                                                                                                   'https://www.energy.gov/gmi/grid-modernization-initiative', target: '_blank', rel: 'noopener noreferrer'}.".html_safe
  end
end
