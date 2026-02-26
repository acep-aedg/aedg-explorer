import mapboxgl from 'mapbox-gl';

let activePopup = null;

const hoverPopup = new mapboxgl.Popup({
  closeButton: false,
  closeOnClick: false,
  offset: 15,
  className: 'modern-click-popup'
});

export function trackPopup(popupInstance) {
  activePopup = popupInstance;
  activePopup.on('close', () => { activePopup = null; });
}

export function defaultPopupTemplate(f) {
  const p = f.properties || f;
  const title = p.title || p.name || 'Location Detail';
  const category = p.category || (p.isMarker ? "Community" : "");

  let contentData = p.content || {};
  if (typeof contentData === 'string') {
    try { contentData = JSON.parse(contentData); } catch (e) { contentData = {}; }
  }

  // Build the list items
  const bodyContent = Object.entries(contentData)
    .map(([label, value]) => {
      let displayValue = (typeof value === 'number') ? value.toLocaleString() : value;

      // If it starts with _ we hide
      if (label.startsWith("_")) {
        return `<li class="location-item">${displayValue}</li>`;
      }

      // Otherwise, we show label title
      return `<div class="data-row"><strong>${label}:</strong> ${displayValue}</div>`;
    })
    .join('');

  return `
    <div class="popup-inner">
      <div class="popup-header">
        <li class="popup-category">${category}</li>
        <p>${title}</p>
      </div>
      ${bodyContent ? `<ul class="popup-body">${bodyContent}</ul>` : ''}
      ${p.path ? `<a href="${p.path}" class="popup-link">View Profile →</a>` : ''}
      <div class="popup-accent-bar"></div>
    </div>
  `;
}

export function attachPopup(map, layerId) {
  // HOVER
  map.on('mousemove', layerId, (e) => {
    const f = e.features?.[0];
    if (!f) return;

    map.getCanvas().style.cursor = 'pointer';

    // Hover now pulls the exact same styles as the click version
    hoverPopup.setLngLat(e.lngLat)
      .setHTML(defaultPopupTemplate(f))
      .addTo(map);
  });

  map.on('mouseleave', layerId, () => {
    map.getCanvas().style.cursor = '';
    hoverPopup.remove();
  });

  // CLICK: Becomes persistent
  map.on('click', layerId, (e) => {
    const f = e.features?.[0];
    if (!f) return;

    hoverPopup.remove();
    if (activePopup) activePopup.remove();

    const newPopup = new mapboxgl.Popup({
      closeButton: true,
      closeOnClick: true,
      offset: 15,
      className: 'modern-click-popup'
    })
      .setLngLat(e.lngLat)
      .setHTML(defaultPopupTemplate(f))
      .addTo(map);

    trackPopup(newPopup);
  });
}