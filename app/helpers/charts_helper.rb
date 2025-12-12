module ChartsHelper
  CHART_COLORS = {
    blue_grey: '#607D8B',
    blue: '#1f77b4',
    orange: '#ff7f0e',
    soft_blue: '#4e79a7',
    soft_orange: '#f28e2b',
    light_blue: '#6BAED6',
    dark_blue: '#08519C',
    light_green: '#74C476',
    dark_green: '#006D2C'
  }.freeze

  # Usage in view: COLORS[:blue] or color(:blue)
  def color(name)
    CHART_COLORS[name]
  end
end
