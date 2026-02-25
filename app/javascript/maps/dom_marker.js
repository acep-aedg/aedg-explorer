import mapboxgl from 'mapbox-gl';

/**
 * A persistent visual pin. 
 * No popups just moves the icon to the current coords.
 */
export function upsertDomMarker(marker, map, data) {
  const coords = [Number(data.lng), Number(data.lat)];

  if (!marker) {
    const el = document.createElement("i");
    el.className = "bi bi-geo-alt-fill dom-marker-icon";
    el.style.cssText = `font-size: 32px; color: #3387d6; text-shadow: 0 0 3px white; pointer-events: none;`;

    marker = new mapboxgl.Marker({ 
      element: el, 
      anchor: "bottom" 
    })
    .setLngLat(coords)
    .addTo(map);
  }

  // Just move the pin
  marker.setLngLat(coords);

  return marker;
}