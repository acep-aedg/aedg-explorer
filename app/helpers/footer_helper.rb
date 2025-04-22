module FooterHelper
  include ActionView::Helpers::UrlHelper

  def footer_links
    [
      { name: 'About AEDG', path: welcome_index_path, title: 'About AEDG' },
      { name: 'FAQ', path: welcome_index_path, title: 'FAQ' },
      { name: 'Contact', path: welcome_index_path, title: 'Contact' },
      { name: 'Privacy Policy', path: welcome_index_path, title: 'Privacy Policy' }
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
