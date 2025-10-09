import mapboxgl from 'mapbox-gl';

export function boundsFrom(geojson) {
  const b = new mapboxgl.LngLatBounds();
  const extend = (c) => {
    if (typeof c[0] === 'number') {
      if (c[0] > 170) c[0] = (c[0] % 360) - 360; // anti-meridian
      b.extend(c);
    } else c.forEach(extend);
  };
  for (const f of geojson.features || []) extend(f.geometry?.coordinates || []);
  return b;
}

export function featureCollectionFromLngLats(points, { title = 'Location' } = {}) {
  const features = (points || []).map(([lng, lat]) => ({
    type: 'Feature',
    geometry: { type: 'Point', coordinates: [lng, lat] },
    properties: { title }
  }))
  return { type: 'FeatureCollection', features }
}
