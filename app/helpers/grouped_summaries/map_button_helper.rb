module GroupedSummaries
  module MapButtonHelper
    def grouped_summary_utilities_map_buttons(parent)
      [
        if parent&.service_areas?
          {
            label: "Utility Service Areas",
            url: polymorphic_path([:service_areas, parent, :maps]),
            icon: "bounding-box",
            id: "service-area"
          }
        end,
        if parent&.local_service_area?
          {
            label: "Local Service Areas",
            url: polymorphic_path([:service_area_geoms, parent, :maps]),
            icon: "bounding-box",
            id: "service-area-geom"
          }
        end,
        if parent&.plants?
          {
            label: "Power Plants",
            url: polymorphic_path([:plants, parent, :maps]),
            icon: "building",
            id: "plant-points"
          }
        end
      ].compact
    end

    def grouped_summary_overview_buttons(parent)
      [
        if parent&.communities?
          {
            label: "Communities",
            url: polymorphic_path([:community_locations, parent, :maps]),
            icon: "people",
            id: "community-locations"
          }
        end,
        if parent&.boundary?
          {
            label: "#{parent.display_title} Boundary",
            url: polymorphic_path([:boundary, parent, :maps]),
            icon: "bounding-box",
            id: parent.boundary_map_layer
          }
        end
      ].compact
    end
  end
end
