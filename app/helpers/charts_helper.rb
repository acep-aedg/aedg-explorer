module ChartsHelper
  # colors show up more vibrant in pie charts, so use the soft variation

  CHART_COLORS = {
    blue: '#1f77b4',
    soft_blue: '#4e79a7',
    blue_grey: '#607D8B',
    light_blue: '#6BAED6',
    dark_blue: '#08519C',
    orange: '#ff7f0e',
    soft_orange: '#f28e2b',
    light_green: '#74C476',
    dark_green: '#006D2C',
    soft_green: '#8EBFA2',
    medium_yellow: '#FDB813',
    light_red: '#D77A7D',
    dark_red: '#810000',
    light_grey: '#D6D6D6',
    medium_grey: '#5D6D7E',
    light_brown: '#A1866F',
    dark_brown: '#6E2C00'
  }.freeze

  # Usage in view: COLORS[:blue] or color(:blue)
  def color(name)
    CHART_COLORS[name]
  end
end
