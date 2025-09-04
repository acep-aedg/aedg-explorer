module CommunitiesHelper
  def nav_link(text, anchor, parent_section: false)
    classes = [
      'dropdown-item',
      'py-1',
      (parent_section ? 'fw-semibold' : 'ps-4')
    ]

    link_to text, anchor.to_s, class: classes.join(' '), data: { turbo: false }
  end
end
