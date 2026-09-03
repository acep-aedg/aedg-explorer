module GridsHelper
  def grid_status_badge(community_grid)
    return tag.span("Prior to #{community_grid.termination_year}", class: "badge bg-light text-muted border ms-2") unless community_grid.active?

    if community_grid.connection_year.to_i.positive?
      tag.span("Since #{community_grid.connection_year}", class: "badge bg-success-subtle text-success-emphasis border border-success-subtle ms-2")
    else
      tag.span("Current", class: "badge bg-success-subtle text-success-emphasis border border-success-subtle ms-2")
    end
  end
end
