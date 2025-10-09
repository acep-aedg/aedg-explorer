export function addPointLayer(map, sourceId) {
  const id = `${sourceId}_points`;
  if (map.getLayer(id)) return id;
  map.addLayer({
    id, type: 'circle', source: sourceId,
    filter: ['==', ['geometry-type'], 'Point'],
    paint: { 'circle-radius': 6, 'circle-color': '#EE4B2B', 'circle-stroke-width': 1, 'circle-stroke-color': '#fff' },
  });
  return id;
}
