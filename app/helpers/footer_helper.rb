module FooterHelper
  include ActionView::Helpers::UrlHelper

  def footer_links
    [
      { name: 'About AEDG', path: about_path, title: 'About AEDG' },
      { name: 'User Guide', path: user_guide_path, title: 'User Guide' }
    ]
  end
end
