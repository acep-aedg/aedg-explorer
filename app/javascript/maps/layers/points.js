export function addPointLayer(map, sourceId, { color = '#EE4B2B', outlineColor = '#ffffff' } = {}) {
  const id = `${sourceId}_points`;
  if (map.getLayer(id)) return id;
  map.addLayer({
    id, type: 'circle', source: sourceId,
    filter: ['==', ['geometry-type'], 'Point'],
    paint: { 'circle-radius': 6, 'circle-color': color, 'circle-stroke-width': 1, 'circle-stroke-color': outlineColor },
  });
  return id;
}
