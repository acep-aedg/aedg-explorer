export const MAP_STYLE = "mapbox://styles/mapbox/streets-v11?optimize=true";
export const DEFAULT_ZOOM = 8;
const COLORS = {
  dark_blue:    "#2E5A88",
  orange:       "#f5945c",
  soft_green:   "#78c2ad",
  dark_red:     "#EE4B2B",
  light_blue:   "#3498db",
  light_brown:  "#a98d60",
  dark_green:   "#2d572c",
  light_red:    "#E74C3C",
  medium_yellow: "#f1c40f",
  dark_brown:   "#786a39",
  purple:       "#563978"
};

export const LAYER_COLORS = {
  "layer-communities":           COLORS.dark_blue,
  "layer-plants":                COLORS.orange,
  "layer-senate":                COLORS.purple,
  "layer-house":                 COLORS.light_red,
  "layer-service-area-local":    COLORS.dark_blue,
  "layer-service-area-utility":  COLORS.medium_yellow,
  "layer-bulk-fuel-facilities":  COLORS.dark_green,
};
