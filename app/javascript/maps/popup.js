import mapboxgl from 'mapbox-gl';

export function defaultPopupTemplate(f) {
  const props = f.properties || {};
  const [lng, lat] = f.geometry?.coordinates || [];

  if (lat && lng) {
    props.coordinates = `${lat.toFixed(4)}, ${lng.toFixed(4)}`;
  }

  const title = props.title || props.name || 'Unknown';
  const titleHtml = props.path
    ? `<a href="${props.path}" class="link-primary">${title}</a>`
    : title;

  const detailsHtml = Object.entries(props)
    .filter(
      ([k, v]) =>
        !['title', 'name', 'path'].includes(k) && v != null && v !== ''
    )
    .map(([k, v]) => {
      const label = k
        .replace(/_/g, ' ')
        .replace(/\b\w/g, (c) => c.toUpperCase());
      return `<div><strong>${label}:</strong> ${v}</div>`;
    })
    .join('');

  return `
    <div class="min-w-220">
      <div class="fs-6 fw-semibold border-bottom mb-2 pb-1">${titleHtml}</div>
      <div>${detailsHtml}</div>
    </div>
  `;
}

export function attachPopup(map, layerId) {
  map.on('click', layerId, (e) => {
    const f = e.features?.[0];
    if (!f) return;

    new mapboxgl.Popup({ offset: 12 })
      .setLngLat(f.geometry.coordinates)
      .setHTML(defaultPopupTemplate(f))
      .addTo(map);
  });

  map.on('mouseenter', layerId, () => {
    map.getCanvas().style.cursor = 'pointer';
  });

  map.on('mouseleave', layerId, () => {
    map.getCanvas().style.cursor = '';
  });
}
