import { fetchGeoJSON } from '../fetch.js'
import { addPolygonLayers } from './polygon.js'
import { addPointLayer } from './points.js'


// Remove all non-"marker:" layers/sources and prune layerIds/sourceIds in place
// export function clearAll(map, layerIds, sourceIds) {
//   const keepLayerIds = []
//   layerIds.forEach(id => {
//     const layer = map.getLayer(id)
//     const srcId = layer?.source
//     if (srcId && srcId.startsWith('marker:')) {
//       keepLayerIds.push(id)
//       return
//     }
//     if (layer) map.removeLayer(id)
//   })
//   layerIds.splice(0, layerIds.length, ...keepLayerIds)

//   const keepSourceIds = []
//   sourceIds.forEach(id => {
//     if (id.startsWith('marker:')) {
//       keepSourceIds.push(id)
//       return
//     }
//     if (map.getSource(id)) map.removeSource(id)
//   })
//   sourceIds.splice(0, sourceIds.length, ...keepSourceIds)
// }

// Add a GeoJSON source or update its data if the source already exists
export function addSource(map, id, data) {
  const src = map.getSource(id)
  if (src) {
    src.setData(data)
    return false
  }
  map.addSource(id, { type: 'geojson', data })
  return true
}

// Remove all layers that use a source, then remove the source (skip "marker:")
export function removeSourceLayers(map, sourceId) {
  if (sourceId.startsWith('marker:')) return
  const style = map.getStyle?.()
  if (style?.layers) {
    for (const layer of [...style.layers]) {
      if (layer.source === sourceId && map.getLayer(layer.id)) map.removeLayer(layer.id)
    }
  }
  if (map.getSource(sourceId)) map.removeSource(sourceId)
}

// Fetch GeoJSON by URL, add as a source, then add polygon/point layers accordingly
export async function loadLayer(map, url, { color, outlineColor } = {}) {
  if (!map.isStyleLoaded()) await new Promise(r => map.once('load', r))
  const fc = await fetchGeoJSON(url)
  const sourceId = sourceIdFrom(url)
  addSource(map, sourceId, fc)
  return addLayersForFC(map, sourceId, fc, { color, outlineColor })
}

// Add a simple circle layer for point features from an inline FeatureCollection
export async function loadMarkerLayer(
  map,
  sourceId,
  fc,
  { iconSize = 1.6, color = '#1DA6B0', strokeColor = '#fff', strokeWidth = 2 } = {}
) {
  if (!map.isStyleLoaded()) await new Promise(r => map.once('load', r))
  addSource(map, sourceId, fc)

  const layerId = `${sourceId}-circle`
  if (!map.getLayer(layerId)) {
    map.addLayer({
      id: layerId,
      type: 'circle',
      source: sourceId,
      filter: ['==', ['geometry-type'], 'Point'],
      paint: {
        'circle-radius': 8 * iconSize,
        'circle-color': color,
        'circle-stroke-color': strokeColor,
        'circle-stroke-width': strokeWidth
      }
    })
  }
  return { fc, sourceId, layerIds: [layerId] }
}

// Internal helper to add polygon or point layers based on first feature’s geometry type
function addLayersForFC(map, sourceId, fc, { color, outlineColor } = {}) {
  const type = fc?.features?.[0]?.geometry?.type || ''
  let layerIds = []
  if (/Polygon/i.test(type)) {
    layerIds = addPolygonLayers(map, sourceId, { color, outlineColor })
  } else {
    const id = addPointLayer(map, sourceId)
    if (id) layerIds.push(id)
  }
  return { fc, sourceId, layerIds }
}

// Build a deterministic source id from a URL path (replace non-word chars with ':')
export function sourceIdFrom(url) {
  return new URL(url, window.location.origin).pathname.replace(/[^\w-]/g, ':')
}
