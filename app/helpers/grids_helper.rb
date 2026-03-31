module GridsHelper
  def grid_navigation_tabs(grid)
    [
      {
        label: "General",
        path: general_grid_path(grid),
        visible: true
      },
      {
        label: "Power Generation",
        path: power_generation_grid_path(grid),
        visible: grid.power_generation?
      }
    ].select { |tab| tab[:visible] }
  end
end
