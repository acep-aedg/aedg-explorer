export function addPolygonLayers(map, sourceId, { color = '#088', outlineColor = '#05505e',  highlightColor = '#ffffff',  beforeId, visibility = 'visible' } = {}) {
  const fillId = `${sourceId}-fill`;
  const lineId = `${sourceId}-outline`;

  if (!map.getLayer(fillId)) {
    map.addLayer({
      id: fillId,
      type: 'fill',
      source: sourceId,
      layout: {
        'visibility': visibility
      },
      paint: {
        'fill-color': color,
        'fill-opacity': [
          'case',
          ['boolean', ['feature-state', 'clicked'], false],
          0.7, // clicked
          0.3  // default
        ]
      }
    }, beforeId);
  }

  if (!map.getLayer(lineId)) {
    map.addLayer({
      id: lineId,
      type: 'line',
      source: sourceId,
      layout: { 'visibility': visibility },
      paint: {
        'line-color': [
          'case',
          ['boolean', ['feature-state', 'clicked'], false],
          highlightColor, // clicked
          outlineColor // Default
        ],
        'line-width': [
          'case',
          ['boolean', ['feature-state', 'clicked'], false],
          2,   // clicked
          1 // default
        ],
        'line-opacity': [
          'case',
          ['boolean', ['feature-state', 'clicked'], false],
          1,   // clicked
          0.5 // default
        ]
      }
    }, beforeId);
  }

  return [fillId, lineId];
}
