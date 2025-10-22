import mapboxgl from 'mapbox-gl';

export function defaultPopupTemplate(f) {
  console.log('Generating popup for feature:', f);
  const props = f.properties || {};

  const [lng, lat] = f.geometry?.coordinates || [];
  if (lat && lng) {
    props.coordinates = `${Number(lat).toFixed(4)}, ${Number(lng).toFixed(
      4
    )}`;
  }

  const title = props.title || props.name || 'Unknown';

  // Build key/value HTML list
  const detailsHtml = Object.entries(props)
    .filter(([k, v]) => k !== 'title' && v != null && v !== '')
    .map(([k, v]) => {
      const label = k
        .replace(/_/g, ' ')
        .replace(/\b\w/g, (c) => c.toUpperCase());
      return `<div><strong>${label}:</strong> ${v}</div>`;
    })
    .join('');

  return `
    <div class="min-w-220">
      <div class="fs-6 fw-semibold border-bottom mb-2 pb-1">
        ${title}
      </div>
      <div>
        ${detailsHtml}
      </div>
    </div>
  `;
}

export function attachPopup(map, layerId) {
  // When the user clicks on a point feature, open a popup
  map.on('click', layerId, (e) => {
    const f = e.features?.[0];
    if (!f) return;
    const coordinates = f.geometry.coordinates.slice();
    const html = defaultPopupTemplate(f);

    new mapboxgl.Popup({ offset: 12 })
      .setLngLat(coordinates)
      .setHTML(html)
      .addTo(map);
  });

  map.on('mouseenter', layerId, () => {
    map.getCanvas().style.cursor = 'pointer';
  });

  map.on('mouseleave', layerId, () => {
    map.getCanvas().style.cursor = '';
  });
}
