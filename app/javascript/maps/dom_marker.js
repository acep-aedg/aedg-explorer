import mapboxgl from "mapbox-gl";

export function upsertDomMarker(marker, map, {
  lng, lat, title,
  iconClass = "bi bi-geo-alt-fill",
  color = "#3387d6ff",
  size = 28
}) {
  const L = Number(lng), A = Number(lat);

  if (!marker) {
    const el = document.createElement("i");
    el.className = iconClass;     // needs bootstrap-icons CSS loaded
    el.style.fontSize = `${size}px`;
    el.style.color = color;
    el.style.textShadow = "0 0 2px white";

    marker = new mapboxgl.Marker({ element: el, anchor: "bottom" })
      .setLngLat([L, A])                                            // <-- set position FIRST
      .setPopup(new mapboxgl.Popup({ offset: 24 }).setHTML(markerHtml(title, L, A)))
      .addTo(map);                                                  // <-- then add to map
  } else {
    marker
      .setLngLat([L, A])
      .setPopup(new mapboxgl.Popup({ offset: 24 }).setHTML(markerHtml(title, L, A)));
  }

  return marker;
}

export function markerHtml(title, lng, lat) {
  const t = title || "Location";
  return `<div><strong>${t}</strong><br/>${Number(lat).toFixed(4)}, ${Number(lng).toFixed(4)}</div>`;
}
