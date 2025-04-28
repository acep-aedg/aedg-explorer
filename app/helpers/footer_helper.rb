module FooterHelper
  include ActionView::Helpers::UrlHelper

  def footer_links
    [
      { name: 'About AEDG', path: about_path, title: 'About AEDG' },
      { name: 'User Guide', path: user_guide_path, title: 'User Guide' }
    ]
  end

  def about_title
    'Alaska Energy Data Gateway'
  end

  def about_text
    'The Alaska Energy Data Gateway is a public resource funded by the State of Alaska to ensure energy and socioeconomic data is easily accessible.'
  end

  def contact_email
    '[AEDG_EMAIL]@alaska.edu'
  end

  def copyright_text
    "© #{Time.current.year} Alaska Center for Energy and Power. All rights reserved."
  end
end
