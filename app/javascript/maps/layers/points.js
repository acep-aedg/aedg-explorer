export function addPointLayer(map, sourceId, { color = '#EE4B2B', outlineColor = '#ffffff', highlightColor = '#05505e', visibility = 'visible' } = {}) {
  const id = `${sourceId}-point`;

  if (map.getLayer(id)) return id;

  map.addLayer({
    id: id,
    type: 'circle',
    source: sourceId,
    filter: ['==', ['geometry-type'], 'Point'],
    layout: {
      'visibility': visibility
    },
    paint: {
      'circle-color': color,
      'circle-radius': [
        'case',
        ['boolean', ['feature-state', 'clicked'], false],
        8, // clicked
        6  // default
      ],
      'circle-stroke-color': [
        'case',
        ['boolean', ['feature-state', 'clicked'], false],
        highlightColor, // clicked
        outlineColor    // default
      ],
      'circle-stroke-width': [
        'case',
        ['boolean', ['feature-state', 'clicked'], false],
        3, // clicked
        1  // default
      ]
    },
  });

  return id;
}
