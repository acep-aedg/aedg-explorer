# Adding a Map Layers

### Add a Layer to the map legend
To add a layer to the map legend add the following to the corresponding map legend section located in the `show.html.haml` file:
```haml
.form-check.mb-1
  %input.form-check-input#layer-id{
    type: "checkbox",
    data: {
      action: "change->maps#toggleLayer",
      url: map_endpoint_path(),
      fit: true
    }
  }
  %label.form-check-label.small{ for: "layer-id" } Map Layer Name
```

### Adding a Map Layer Button

Add a button to the view, if the layer already exists in the map legend, ensure `checkbox_id` is set to the id of the checkbox in the map legend.

```haml
%button.btn.btn-sm.btn-outline-secondary.d-inline-flex.align-items-center.gap-1{
  data: {
    action: "click->maps#showLayer",
    url: map_endpoint_path(),
    fit: true,
    checkbox_id: "layer-id" # toggles checkbox in map panel, ensure checkbox exists
  }
}
  %i.bi.bi-building
  Map Layer Name
```


### Add a default layer to the map
This will trigger the layer to be on by default.
```haml
.row.gx-0{
  data: mapbox_api_data({
    maps_default_layer_id_value: "layer-communities" # must match %input.form-check-input#layer-id from map legend
  })
}
```

### Add a default marker and a center value
```haml
.row.gx-0{
  data: mapbox_api_data({
    maps_map_center_value: [@community.longitude, @community.latitude],
    maps_markers_value: [[@community.longitude, @community.latitude]],
    maps_marker_tooltip_title_value: @community.name
  })
}
```


### Configure Map Layer Colors

Add the map `layer-id` and `color` to the `LAYER_COLORS` object in `javascript/maps/config.js`, this will ensure that any layer with the `layer-id` regardless of where it is added to the map will be displayed with consistent colors.

```js
export const LAYER_COLORS = {
  "layer-communities": "#75ba75",
  "layer-plants": "#088",
  "layer-senate": "#fec76f",
  "layer-id": "#newcolor"
};

```

To override or pass in custom colors pass in the `color` and or `outline_color`, this will only overide the instance of the map layer, it will NOT update or override layers triggered elsewhere with the same `layer-id`.

```haml
%button.btn.btn-sm.btn-outline-secondary.d-inline-flex.align-items-center.gap-1{
  data: {
    action: "click->maps#showLayer",
    url: plants_community_maps_path(@community),
    fit: true,
    checkbox_id: "layer-plants", # toggles checkbox in map panel, ensure checkbox exists
    color: "#FF0000",
    outline_color: "#ffffff"
  }
}
  %i.bi.bi-building
  Power Plants
```
If no `outline_color` is passed in, the outline color will be a darkened version of the `color`.
```haml
%button.btn.btn-sm.btn-outline-secondary.d-inline-flex.align-items-center.gap-1{
  data: {
    action: "click->maps#showLayer",
    url: plants_community_maps_path(@community),
    fit: true,
    checkbox_id: "layer-id", # toggles checkbox in map panel, ensure checkbox exists
    color: "#FF0000",
  }
}
  %i.bi.bi-building
  Power Plants
```
