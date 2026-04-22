export const MAP_STYLE = "mapbox://styles/mapbox/streets-v11?optimize=true";
export const DEFAULT_ZOOM = 8;

// 'export' to use in other files
export const COLORS = {
  dark_blue:    "#2E5A88",
  orange:       "#f5945c",
  soft_green:   "#78c2ad",
  dark_red:     "#EE4B2B",
  light_blue:   "#3498db",
  light_brown:  "#a98d60",
  dark_green:   "#2d572c",
  light_red:    "#E74C3C",
  medium_yellow: "#f1c40f",
  dark_brown:   "#786a39",
  purple:       "#563978"
};

export const LAYER_COLORS = {
  "community_locations":           COLORS.dark_blue,
  "plants-points":                COLORS.orange,
  "senate-districts":                COLORS.purple,
  "house-districts":                 COLORS.light_red,
  "service-area-geom":    COLORS.dark_blue,
  "service-area":  COLORS.medium_yellow,
  "bulk-fuel-facilities-points":  COLORS.dark_green,
  "boroughs": COLORS.dark_brown,
};
