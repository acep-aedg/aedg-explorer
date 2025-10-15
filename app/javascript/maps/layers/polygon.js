export function addPolygonLayers(map, sourceId, { color = '#088', outlineColor = '#05505e' } = {}) {
  const fillId = `${sourceId}-fill`;
  const lineId = `${sourceId}-outline`;

  if (!map.getLayer(fillId)) {
    map.addLayer({ id: fillId, type: 'fill', source: sourceId,
      paint: { 'fill-color': color, 'fill-opacity': 0.4 } });
  }
  if (!map.getLayer(lineId)) {
    map.addLayer({ id: lineId, type: 'line', source: sourceId,
      paint: { 'line-color': outlineColor, 'line-width': 2, 'line-opacity': 0.8 } });
  }
  return [fillId, lineId];
}
