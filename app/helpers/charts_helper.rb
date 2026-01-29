module ChartsHelper
  # colors show up more vibrant in pie charts, so use the soft variation

  CHART_COLORS = {
    # Blues
    blue: "#1f77b4",
    soft_blue: "#4e79a7",
    blue_grey: "#607D8B",
    light_blue: "#6BAED6",
    dark_blue: "#08519C",
    cyan: "#17becf",

    # Oranges/Browns
    orange: "#ff7f0e",
    soft_orange: "#f28e2b",
    rust: "#d35400",
    light_brown: "#A1866F",
    dark_brown: "#6E2C00",
    sienna: "#8c564b",
    gold: "#bcbd22",

    # Greens
    light_green: "#74C476",
    dark_green: "#006D2C",
    soft_green: "#8EBFA2",
    olive: "#556B2F",

    # Reds/Pinks
    light_red: "#D77A7D",
    dark_red: "#810000",
    pink: "#e377c2",

    # Greys/Blacks
    light_grey: "#D6D6D6",
    medium_grey: "#5D6D7E",
    charcoal: "#34495e",

    # Yellows/Purples
    medium_yellow: "#FDB813",
    purple: "#9b59b6",
    dark_purple: "#6c3483"
  }.freeze

  FUEL_COLOR_MAPPING = {
    "CL" => :light_grey,
    "DFO" => :soft_orange,
    "JF" => :light_red,
    "LFG" => :light_brown,
    "MWH" => :medium_grey,
    "NG" => :soft_green,
    "SUN" => :medium_yellow,
    "WAT" => :blue,
    "WH" => :dark_red,
    "WND" => :light_blue,
    "WO" => :dark_brown,
    "WDS" => :sienna,
    "OBL" => :pink,
    "AB" => :gold,
    "OG" => :cyan,
    "BIT" => :charcoal,
    "RFO" => :rust,

    "kwh_purchased" => :purple
  }.freeze

  class HexColor < String
    def to_opaque(opacity = 1)
      return self unless match(/^#(..)(..)(..)$/)

      rgb = match(/^#(..)(..)(..)$/).captures.map(&:hex)
      "rgba(#{rgb.join(', ')}, #{opacity})"
    end
  end

  module_function

  # Usage in view: COLORS[:blue] or color(:blue)
  def color(name)
    val = CHART_COLORS[name]
    val ? HexColor.new(val) : nil
  end

  def fuel_color(code)
    color_name = FUEL_COLOR_MAPPING[code]
    hex = CHART_COLORS[color_name] || CHART_COLORS[:medium_grey]

    HexColor.new(hex)
  end
end
