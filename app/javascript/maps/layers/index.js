import { fetchGeoJSON } from '../fetch.js'
import { addPolygonLayers } from './polygon.js'
import { addPointLayer } from './points.js'
import { attachPopup, detachPopup } from '../popup.js'

/**
 * Add a GeoJSON source or update its data if the source already exists.
 */
export function addSource(map, id, data) {
  const src = map.getSource(id)
  if (src) {
    src.setData(data)
    return false
  }
  map.addSource(id, { type: 'geojson', data })
  return true
}

/**
 * Remove all layers that use a specific source, then remove the source itself.
 */
export function removeSourceLayers(map, sourceId) {
  if (sourceId.startsWith('marker:')) return
  
  const style = map.getStyle?.()
  if (style?.layers) {
    for (const layer of [...style.layers]) {
      if (layer.source === sourceId && map.getLayer(layer.id)) {
        detachPopup(layer.id)
        map.removeLayer(layer.id)
      }
    }
  }
  
  if (map.getSource(sourceId)) {
    map.removeSource(sourceId)
  }
}

/**
 * Main entry point to fetch and load a layer from a URL.
 * Now uses .then() instead of await to maintain sync-like flow.
 */
export function loadLayer(map, url, { color, outlineColor, visibility = 'visible' } = {}) {
  // We return the promise so the controller can track completion
  return fetchGeoJSON(url).then(fc => {
    const sourceId = sourceIdFrom(url)
    addSource(map, sourceId, fc)
    
    const result = addLayersForFC(map, sourceId, fc, { color, outlineColor, visibility })
    return { ...result, fc } // Return everything the controller needs
  })
}

/**
 * Specifically adds a circle layer for marker-style point features.
 * Removed async/await style checks (handled by controller load event).
 */
export function loadMarkerLayer(
  map,
  sourceId,
  fc,
  { iconSize = 1.6, color = '#1DA6B0', strokeColor = '#fff', strokeWidth = 2, visibility = 'visible' } = {}
) {
  addSource(map, sourceId, fc)

  const layerId = `${sourceId}-circle`
  if (!map.getLayer(layerId)) {
    map.addLayer({
      id: layerId,
      type: 'circle',
      source: sourceId,
      filter: ['==', ['geometry-type'], 'Point'],
      layout: {
        'visibility': visibility
      },
      paint: {
        'circle-radius': 8 * iconSize,
        'circle-color': color,
        'circle-stroke-color': strokeColor,
        'circle-stroke-width': strokeWidth
      }
    })
  }
  
  attachPopup(map, layerId)
  
  return { fc, sourceId, layerIds: [layerId] }
}

/**
 * Internal helper to add polygon or point layers based on geometry.
 * Synchronously adds layers to the map.
 */
function addLayersForFC(map, sourceId, fc, { color, outlineColor, visibility = 'visible' } = {}) {
  const type = fc?.features?.[0]?.geometry?.type || ''
  let layerIds = []

  if (/Polygon/i.test(type)) {
    // Put polygons UNDER the anchor
    const beforeId = map.getLayer('polygon-anchor') ? 'polygon-anchor' : undefined
    layerIds = addPolygonLayers(map, sourceId, { color, outlineColor, beforeId, visibility })
  } else {
    // Put points OVER the anchor (on top)
    const id = addPointLayer(map, sourceId, { color, outlineColor, visibility })
    if (id) layerIds.push(id)
  }

  return { sourceId, layerIds }
}

/**
 * Generates a clean source ID from a URL.
 */
export function sourceIdFrom(url) {
  return new URL(url, window.location.origin).pathname.replace(/[^\w-]/g, ':')
}