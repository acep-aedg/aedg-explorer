module GridsHelper
  def grid_status_badge(grid)
    # if termination_year != 9999
    return tag.span("Prior to #{grid.termination_year}", class: "badge bg-light text-secondary border ms-2") unless grid.active?

    # connection_year > 0 
    if grid.connection_year.to_i.positive? 
      tag.span("Since #{grid.connection_year}", class: "badge bg-success-subtle text-success border border-success-subtle ms-2")
    else
      tag.span("Current", class: "badge bg-success-subtle text-success border border-success-subtle ms-2")
    end
  end
end
