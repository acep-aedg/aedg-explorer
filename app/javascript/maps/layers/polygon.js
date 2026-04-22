export function addPolygonLayers(map, sourceId, { color = '#088', outlineColor = '#05505e', beforeId, visibility = 'visible' } = {}) {
  const fillId = `${sourceId}-fill`;
  const lineId = `${sourceId}-outline`;

  if (!map.getLayer(fillId)) {
    map.addLayer({ 
      id: fillId, 
      type: 'fill', 
      source: sourceId,
      layout: {
        'visibility': visibility // Added this
      },
      paint: { 'fill-color': color, 'fill-opacity': 0.4 } 
    }, beforeId); 
  }
  
  if (!map.getLayer(lineId)) {
    map.addLayer({ 
      id: lineId, 
      type: 'line', 
      source: sourceId,
      layout: {
        'visibility': visibility // Added this
      },
      paint: { 'line-color': outlineColor, 'line-width': 2, 'line-opacity': 0.8 } 
    }, beforeId); 
  }
  
  return [fillId, lineId];
}