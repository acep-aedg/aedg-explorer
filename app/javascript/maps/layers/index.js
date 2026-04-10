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
 * This now properly detaches popup listeners to prevent errors when clicking.
 */
export function removeSourceLayers(map, sourceId) {
  if (sourceId.startsWith('marker:')) return
  
  const style = map.getStyle?.()
  if (style?.layers) {
    for (const layer of [...style.layers]) {
      if (layer.source === sourceId && map.getLayer(layer.id)) {
        // Unregister the layer from our popup management system
        detachPopup(layer.id)
        // Remove the layer from the map
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
 */
export async function loadLayer(map, url, { color, outlineColor } = {}) {
  if (!map.isStyleLoaded()) await new Promise((r) => map.once('load', r))
  const fc = await fetchGeoJSON(url)
  const sourceId = sourceIdFrom(url)
  addSource(map, sourceId, fc)
  return addLayersForFC(map, sourceId, fc, { color, outlineColor })
}

/**
 * Specifically adds a circle layer for marker-style point features.
 */
export async function loadMarkerLayer(
  map,
  sourceId,
  fc,
  { iconSize = 1.6, color = '#1DA6B0', strokeColor = '#fff', strokeWidth = 2 } = {}
) {
  if (!map.isStyleLoaded()) await new Promise((r) => map.once('load', r))
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
  
  // Attach popup to markers too
  attachPopup(map, layerId)
  
  return { fc, sourceId, layerIds: [layerId] }
}

/**
 * Internal helper to add polygon or point layers based on geometry.
 * Uses 'polygon-anchor' (defined in Stimulus controller) to maintain stacking.
 */
function addLayersForFC(map, sourceId, fc, { color, outlineColor } = {}) {
  const type = fc?.features?.[0]?.geometry?.type || ''
  let layerIds = []

  if (/Polygon/i.test(type)) {
    /**
     * Mapbox Way: We insert polygons BEFORE the anchor layer.
     * This ensures points (added without a beforeId) stay on top.
     */
    const beforeId = map.getLayer('polygon-anchor') ? 'polygon-anchor' : undefined
    layerIds = addPolygonLayers(map, sourceId, { color, outlineColor, beforeId })
  } else {
    // Points are added to the very top by default
    const id = addPointLayer(map, sourceId, { color, outlineColor })
    if (id) layerIds.push(id)
  }

  // Register these layers with our global click handler
  layerIds.forEach(id => attachPopup(map, id))

  return { fc, sourceId, layerIds }
}

/**
 * Generates a clean source ID from a URL.
 */
export function sourceIdFrom(url) {
  return new URL(url, window.location.origin).pathname.replace(/[^\w-]/g, ':')
}