module CommunitiesHelper
  def nav_link(text, anchor, parent_section: false)
    link_to text, anchor.to_s, class: "nav-link #{parent_section ? 'fw-semibold' : 'ps-4'} py-1", data: { turbo: false }
  end
end
